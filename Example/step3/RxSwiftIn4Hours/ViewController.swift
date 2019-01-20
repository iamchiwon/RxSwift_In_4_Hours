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
}
