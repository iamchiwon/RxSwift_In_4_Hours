# RxSwift 4시간에 끝내기

![](docs/rxswift_in_4_hours_logo.png)

<br/>

## Preface

요즘 관심이 높은 RxSwift!

RxSwift는 Swift에 ReactiveX를 적용시켜 비동기 프로그래밍을 직관적으로 작성할 수 있도록 도와주는 **라이브러리**입니다. 

즉, RxSwift는 도구입니다. 하지만 높은 러닝커브에 쉽게 접근하지 못하는 분이 많습니다.<br/>
도구를 이용하려고 배우고 노력하는 시간이 너무 큰 것은 배보다 배꼽이 더 큰 격입니다.<br/>
RxSwift의 근본적인 학습 자체보다는, 빠르게 사용법을 익혀 프로젝트에 적용하는 것이 *현실주의 프로그래머들에게는* 더 중요합니다.

<br/>

## Contents

### 1. 개념잡기

#### 동기/비동기
- Blocking / Non-Blocking
	- Sync / Async
	- Thread, Concurrent, Parallel
	- [Concurrency Programming Guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html)
	- pthread, Thread, Operation, OperationQueue, GCD
- Async Result 의 처리
	- Closure Callback
	- Delegate
	- 나중에 Wrapper

#### 나중에 Wrapper
- [PromiseKit](https://github.com/mxcl/PromiseKit)
- [Bolts](https://github.com/BoltsFramework/Bolts-Swift)
- [RxSwift](https://github.com/ReactiveX/RxSwift)

<br/>
	
### 2. 기본 사용법

#### Observable
- Observable `create`
- subscribe 로 데이터 사용
- Disposable 로 작업 취소
- stream의 life-cycle
	- Subscribed
	- Next
	- Completed / Error
	- Disposabled

<br/>

### 3. Sugar API

#### Operators
- 간단한 생성 : `just`, `from`
- 필터링 : `filter`, `take`
- 데이터 변형 : `map`, `flatMap`
- 그 외 : [A Decision Tree of Observable Operators](http://reactivex.io/documentation/ko/operators.html)
- Marble Diagram
  - [http://rxmarbles.com/](http://rxmarbles.com/)
  - [http://reactivex.io/documentation/operators.html](http://reactivex.io/documentation/operators.html)
  - [https://itunes.apple.com/us/app/rxmarbles/id1087272442?mt=8](https://itunes.apple.com/us/app/rxmarbles/id1087272442?mt=8)

#### Schedulers
- DispatchQueue
- `observeOn`, `subscribeOn`

#### Subject
- Data Control
- Hot Observable / Cold Observable

<br/>

### 4. RxCocoa

- UI 작업의 특징
- Observable / Driver
- Subject / Relay

<br/>

### 5. Extension

- [RxViewController](https://github.com/devxoul/RxViewController)
- [RxOptional](https://github.com/RxSwiftCommunity/RxOptional)
- [RxExtension](https://github.com/tokijh/RxSwiftExtensions)
- [RxSwift Community Projects](https://community.rxswift.org/)
<br/><br/>
- [methodInvoked Example](https://gist.github.com/iamchiwon/bd200395a0d0ced65d91d0fa7abe54cb)
- [DelegateProxy example](https://gist.github.com/iamchiwon/f007d67c8365b612daa99d6f19ad3992)

<br/>

### 6. Test

- [RxBlocking](https://github.com/ReactiveX/RxSwift/tree/master/RxBlocking)
- [RxTest](https://github.com/ReactiveX/RxSwift/tree/master/RxTest)
- [Video] [Testing an operator with TestScheduler - RxSwift](https://www.youtube.com/watch?v=HKigVK1eqwE)
- [Video] [Understanding RxSwift using RxTests — Yvette Cook](https://www.youtube.com/watch?v=FgbTenGH-P0)
- [Article] [Testing Your RxSwift Code](https://www.raywenderlich.com/7408-testing-your-rxswift-code)

<br/>

## References

- [Official] [ReactiveX](http://reactivex.io/)
- [Video] [RxSwift 4시간에 끝내기](https://www.youtube.com/watch?v=w5Qmie-GbiA&index=1&list=PL03rJBlpwTaAh5zfc8KWALc3ADgugJwjq)<br/>
  ![]()
  [![오프라인 모임 종햡편](https://img.youtube.com/vi/w5Qmie-GbiA/0.jpg)](https://www.youtube.com/watch?v=w5Qmie-GbiA&index=1&list=PL03rJBlpwTaAh5zfc8KWALc3ADgugJwjq)
- Unfinished Observable / Memory Leak
	- (참조) [클로져와 메모리 해제 실험](https://iamchiwon.github.io/2018/08/13/closure-mem/)
- [카카오톡 RxSwift 오픈 채팅방](https://open.kakao.com/o/gl2YZjq)

<br/>

## License

![](docs/cc_license.png)
<br />이 저작물은 <a rel="license" href="http://creativecommons.org/licenses/by/2.0/kr/">크리에이티브 커먼즈 저작자표시 2.0 대한민국 라이선스</a>에 따라 이용할 수 있습니다.

<br/>
