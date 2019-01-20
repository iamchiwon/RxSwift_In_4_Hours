//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    let viewModel = ViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: - Bind UI

    private func bindUI() {
        // INPUT
        idField.rx.text.orEmpty
            .subscribe(onNext: viewModel.emailInput)
            .disposed(by: disposeBag)

        pwField.rx.text.orEmpty
            .subscribe(onNext: viewModel.passwordInput)
            .disposed(by: disposeBag)

        loginButton.rx.tap.asObservable()
            .withLatestFrom(idField.rx.text.orEmpty)
            .withLatestFrom(pwField.rx.text.orEmpty) { ($0, $1) }
            .flatMap { self.viewModel.login(email: $0, pass: $1) }
            .filter { $0 }
            .map { _ in () }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: goLoginSuccessViewController)
            .disposed(by: disposeBag)

        // OUTPUT
        viewModel.idBulletVisible
            .map { !$0 }
            .bind(to: idValidView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.pwBulletVisible
            .map { !$0 }
            .bind(to: pwValidView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.loginEnable
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.progressVisible
            .observeOn(MainScheduler.instance)
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .map { $0 as NSError }
            .map { $0.domain }
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
