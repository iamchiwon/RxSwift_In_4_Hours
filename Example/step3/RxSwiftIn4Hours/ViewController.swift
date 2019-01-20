//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = ViewReactor()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: - Bind UI

    func bind(reactor: ViewReactor) {
        // INPUT

        idField.rx.text.orEmpty
            .map { ViewReactor.Action.email($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        pwField.rx.text.orEmpty
            .map { ViewReactor.Action.password($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .withLatestFrom(idField.rx.text.orEmpty)
            .withLatestFrom(pwField.rx.text.orEmpty) { ($0, $1) }
            .map { ViewReactor.Action.login($0.0, $0.1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // OUTPUT

        reactor.state.map { $0.idBulletVisible }
            .map { !$0 }
            .bind(to: idValidView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.pwBulletVisible }
            .map { !$0 }
            .bind(to: pwValidView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.loginEnable }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state.map { $0.progressVisible }
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .map { $0 as NSError? }
            .map { $0?.domain ?? "" }
            .subscribe(onNext: alert)
            .disposed(by: disposeBag)
    }

    func goLoginSuccessViewController() {
        guard let toVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginSuccessViewController") else { return }
        navigationController?.pushViewController(toVC, animated: true)
    }

    func alert(_ text: String) {
        let alert = UIAlertController(title: "Error",
                                      message: text,
                                      preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)

        present(alert, animated: true, completion: nil)
    }
}
