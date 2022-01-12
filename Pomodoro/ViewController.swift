//
//  ViewController.swift
//  Pomodoro
//
//  Created by UAPMobile on 2022/01/12.
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var duration = 60
    var timerStatus: TimerStatus = .end  // 꺼져있는 것이 기본값
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    // 타이머 설정 및 시작
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now() + 0, repeating: 1) // .now() 즉시 실행
            // timer 동작마다 eventhandler 가 동작한다
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                
                UIView.animate(withDuration: 0.25, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: (.pi / 2) * 1)
                })
                UIView.animate(withDuration: 0.25, delay: 0.25, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: (.pi / 2) * 2)
                })
                UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: (.pi / 2) * 3)
                })
                UIView.animate(withDuration: 0.25, delay: 0.75, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: (.pi / 2) * 4)
                })
                
                if self.currentSeconds <= 0 {
                    // 타이머 종료
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)  // https://iphonedev.wiki/index.php/AudioServices
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()  // timer.suspend 상태 (아직 수행할 작업이 있는 상태)에서 nil을 넣으면 runtime error 발생 => resume 호출 해야함
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity
        })
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil  // 메모리에서 해제
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
            
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()  // timer 중지
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
        }
    }
}

