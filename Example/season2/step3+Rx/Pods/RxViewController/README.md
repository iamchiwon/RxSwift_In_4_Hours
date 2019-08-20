# RxViewController

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/RxViewController.svg)](https://cocoapods.org/pods/RxViewController)
[![Build Status](https://travis-ci.org/devxoul/RxViewController.svg?branch=master)](https://travis-ci.org/devxoul/RxViewController)
[![codecov](https://img.shields.io/codecov/c/github/devxoul/RxViewController.svg)](https://codecov.io/gh/devxoul/RxViewController)

RxSwift wrapper for UIViewController and NSViewController.

## At a Glance

In the view controller:

```swift
self.rx.viewDidLoad
  .subscribe(onNext: {
    print("viewDidLoad 🎉")
  })
```

## APIs

```swift
extension Reactive where Base: UIViewController {
  var viewDidLoad: ControlEvent<Void>

  var viewWillAppear: ControlEvent<Bool>
  var viewDidAppear: ControlEvent<Bool>

  var viewWillDisappear: ControlEvent<Bool>
  var viewDidDisappear: ControlEvent<Bool>

  var viewWillLayoutSubviews: ControlEvent<Void>
  var viewDidLayoutSubviews: ControlEvent<Void>

  var willMoveToParentViewController: ControlEvent<UIViewController?>
  var didMoveToParentViewController: ControlEvent<UIViewController?>

  var didReceiveMemoryWarning: ControlEvent<Void>
}
```

```swift
public extension Reactive where Base: NSViewController {
  var viewDidLoad: ControlEvent<Void>

  var viewWillAppear: ControlEvent<Void>
  var viewDidAppear: ControlEvent<Void>

  var viewWillDisappear: ControlEvent<Void>
  var viewDidDisappear: ControlEvent<Void>

  var viewWillLayout: ControlEvent<Void>
  var viewDidLayout: ControlEvent<Void>
}
```

## Installation

* **Using [CocoaPods](https://cocoapods.org)**:

    ```ruby
    pod 'RxViewController'
    ```

* **Using [Carthage](https://github.com/Carthage/Carthage)**:

    ```
    github "devxoul/RxViewController"
    ```

## Contributing

Any discussions and pull requests are welcomed 💖

To create a Xcode project:

```console
$ swift package generate-xcodeproj
```

## License

RxViewController is under MIT license. See the [LICENSE](LICENSE) file for more info.
