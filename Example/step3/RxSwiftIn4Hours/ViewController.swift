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
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        idField.addTarget(self, action: #selector(checkIdValid), for: .editingChanged)
        pwField.addTarget(self, action: #selector(checkPwValid), for: .editingChanged)
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - EVENT

    @objc func checkIdValid() {
        guard let text = idField.text else {
            idValidView.isHidden = true
            return
        }
        if text.isEmpty {
            idValidView.isHidden = true
            return
        }
        idValidView.isHidden = checkEmailValid(text)

        checkLoginButton()
    }

    @objc func checkPwValid() {
        guard let text = pwField.text else {
            pwValidView.isHidden = true
            return
        }
        if text.isEmpty {
            pwValidView.isHidden = true
            return
        }
        pwValidView.isHidden = checkPasswordValid(text)

        checkLoginButton()
    }

    func checkLoginButton() {
        guard let email = idField.text else { return }
        guard let password = pwField.text else { return }
        guard !email.isEmpty else { return }
        guard !password.isEmpty else { return }
        
        loginButton.isEnabled = idValidView.isHidden && pwValidView.isHidden
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
