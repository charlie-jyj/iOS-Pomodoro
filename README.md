##  pomodoro app

> 뽀모도로 타이머 앱

### 1) 구현 기능
- DatePicker => 타이머 시간 설정 
- 시작, 일시정지, 취소, 카운트 다운 완료 시 알람

### 2) 기본 개념
#### (1) DispatchSourceTimer
- 일정 시간이 지난 후에 이벤트 발생 시키기 (settimeout)
- 반복적으로 특정 작업을 수행하기 (setinterval)
- swift timer 클래스가 있지만 
- GCD API 사용

**GCD API
멀티쓰레드 구현
- Grand Central Dispatcher
- dispatch queue = main (serial) + global (concurrent)
인터페이스와 관련된 코드는 메인 스레드에서 실행되어야 한다
코코아가 메인에서 실행되기 때문 

DispatchSource
: an object that coordinates the processing of specific low-level system events,
Such as file-system events, timers, and UNIX signals

<protocol>
DispatchsourceTimer

<func>
DispatchSource.makeTimerSource
: creates a new dispatch source object for monitoring timer events
-flag : additional flags indicating the behavior of the timer, for a list of possible values
-dispatch queue : where to execute the installed handler
Return -> a dispatch source object that conforms to the dispatchSourceTimer protocol

timer.schedule
- deadline : 몇초의 delay?
- repeating: 몇초마다 반복?

#### (2) UIView Animation
UIView.animate()
-withduration : 지속 시간
-animation : closure 안에 최종 값 입력

#### (3) AudioToolBox


### 3) 새롭게 알게 된 것 
- git 에 push 를 해보려고 애쓰다 보니.. 
맥에서 키체인에 등록된 계정을 바꾸어주어야 한다는 것을 발견
=> 나중에 회사 계정으로 돌려놓자

- xcode에서 프로젝트 생성할 때 이미 git init이 되어있으니 
다시 init 해서 꼬여버리는 일이 생겼다..
find ./ -name ".git" | xargs rm -Rf
출처: https://doraeul.tistory.com/207 
Git 폴더를 지워버린 후에 해결했다

- self.timer = nil
nil을 할당하면 메모리에서 해제된다는 점..
해제하지 않는다면 화면 밖에서 타이머가 계속 동작할 수 있다 <주의>

- timer 메서드
 resume : re + assume = start again/ cancel / suspend 

Suspend 상태에서 cancel 된 타이머에 nil을 대입할 경우
Runtime error 가 발생한다. => 아직 수행할 작업이 있다고 판단하기 때문

https://developer.apple.com/documentation/dispatch/dispatchobject/1452801-suspend

Calling this function increments the suspension count of the object and calling resume() decrements it
/ to release an object that is currently suspended => error
Because suspension implies that there is still work to be done.
Always balance calls to this method with a corresponding call to resume() before disposing of the object**

- string format specifier 
= format string
%f : float
%d: decimal
%@: String

- CGAffineTransform
Struct
뷰의 프레임을 계산하지 않고 2D 그래픽을 그린다
아핀 변환 행렬
객체 회전, 크기조절(scale), 기울기…



