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

    // MARK: - Bind UI

    private func bindUI() {
        // INPUT
        idField.rx.text.orEmpty
            .subscribe(onNext: viewModel.emailInput)
            .disposed(by: disposeBag)

        pwField.rx.text.orEmpty
            .subscribe(onNext: viewModel.passwordInput)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .flatMap { _ in
                self.viewModel.login(email: self.idField.text!, pass: self.pwField.text!)
                    .observeOn(MainScheduler.instance)
                    .do(onError: { err in
                        let nsError = err as NSError
                        let failMessage = nsError.domain
                        self.alert(failMessage)
                    })
                    .catchErrorJustReturn(false)
            }
            .filter { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.goLoginSuccessViewController()
            })
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
