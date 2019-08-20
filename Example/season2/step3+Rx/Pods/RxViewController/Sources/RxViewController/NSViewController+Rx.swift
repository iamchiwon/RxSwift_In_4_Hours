#if os(macOS)
import AppKit

import RxCocoa
import RxSwift

public extension Reactive where Base: NSViewController {
  var viewDidLoad: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }

  var viewWillAppear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
    return ControlEvent(events: source)
  }
  var viewDidAppear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { _ in }
    return ControlEvent(events: source)
  }

  var viewWillDisappear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { _ in }
    return ControlEvent(events: source)
  }
  var viewDidDisappear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { _ in }
    return ControlEvent(events: source)
  }

  var viewWillLayout: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillLayout)).map { _ in }
    return ControlEvent(events: source)
  }
  var viewDidLayout: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLayout)).map { _ in }
    return ControlEvent(events: source)
  }
}
#endif
