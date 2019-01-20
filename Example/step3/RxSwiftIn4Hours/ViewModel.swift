//
//  ViewModel.swift
//  RxSwiftIn4Hours
//
//  Created by Song Chiwon on 20/01/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel {
    let idBulletVisible = BehaviorSubject<Bool>(value: true)
    let pwBulletVisible = BehaviorSubject<Bool>(value: true)
    let loginEnable = BehaviorSubject<Bool>(value: false)
    
    private let disposBag = DisposeBag()
    private let idValidated = BehaviorSubject<Bool>(value: false)
    private let pwValidated = BehaviorSubject<Bool>(value: false)
    
    init() {
        Observable.combineLatest(idValidated, pwValidated) { $0 && $1 }
            .bind(to: loginEnable)
            .disposed(by: disposBag)
    }
    
    func emailInput(_ text: String) {
        let valid = checkEmailValid(text)
        let bulletVisible = !valid || text.isEmpty
        idValidated.onNext(valid)
        idBulletVisible.onNext(bulletVisible)
    }
    
    func passwordInput(_ text: String) {
        let valid = checkPasswordValid(text)
        let bulletVisible = !valid || text.isEmpty
        pwValidated.onNext(valid)
        pwBulletVisible.onNext(bulletVisible)
    }
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
