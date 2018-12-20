# RxSwift 4시간에 끝내기

## Contents

### 1. 기본
#### 공식 사이트 둘러보기
- [http://reactivex.io/](http://reactivex.io/)
- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 동기/비동기
- 동기
```swift
@IBAction func onLoadSync(_ sender: Any) {
    guard let url = URL(string: imageUrl1) else { return }
    guard let data = try? Data(contentsOf: url) else { return }
    
    let image = UIImage(data: data)
    imageView.image = image
}
```
- 비동기
```swift
@IBAction func onLoadAsync(_ sender: Any) {
    DispatchQueue.global().async {
        guard let url = URL(string: self.imageUrl1) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        let image = UIImage(data: data)
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}
```

#### 라이브러리 (PromiseKit)
```swift
promiseLoadImage(from: loadingImageUrl)
    .done { image in
        self.imageView.image = image
    }.catch { error in
        print(error.localizedDescription)
}
```

#### RxSwift
```swift
_ = rxswiftLoadImage(from: loadingImageUrl)
    .observeOn(MainScheduler.instance)
    .subscribe({ result in
        switch result {
        case let .next(image):
            self.imageView.image = image

        case let .error(err):
            print(err.localizedDescription)

        case .completed:
            break
        }
    })
```

#### Disposable/DisposeBag
```swift
var disposable: Disposable?
disposable?.dispose()
```
```swift
var disposeBag = DisposeBag()
```

<br/>

### 2. 사용법
- just, from
- map, flatMap
- filter
- next, error completed
- marbles
- side-effect

<br/>

### 3. 응용
- Subject, Relay
- Other Operators
     take, delay, interval, 
     combine, merge, zip
- Unfinished Observable
- Momory Leak

<br/>

### 4. 확장
- RxCocoa
  - Driver
  - binding
- RxViewController
- RxOptional
- RxExtension
- extension

<br/>

## License

![](docs/cc_license.png)
<br />이 저작물은 <a rel="license" href="http://creativecommons.org/licenses/by/2.0/kr/">크리에이티브 커먼즈 저작자표시 2.0 대한민국 라이선스</a>에 따라 이용할 수 있습니다.