//
//  ViewModel.swift
//  RxSwiftIn4Hours
//
//  Created by Song Chiwon on 20/01/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class ViewModel {
    let idBulletVisible = BehaviorSubject<Bool>(value: true)
    let pwBulletVisible = BehaviorSubject<Bool>(value: true)
    let loginEnable = BehaviorSubject<Bool>(value: false)

    let progressVisible = BehaviorSubject<Bool>(value: false)
    let errorMessage = PublishSubject<Error>()

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

    func login(email: String, pass: String) -> Observable<Bool> {
        let successUrl = "https://raw.githubusercontent.com/iamchiwon/RxSwift_In_4_Hours/master/docs/login_ok.json"
        let failUrl = "https://raw.githubusercontent.com/iamchiwon/RxSwift_In_4_Hours/master/docs/login_fail.json"

        let randomIndex = Int(arc4random() % 2)
        let selected = [successUrl, failUrl][randomIndex]

        progressVisible.onNext(true)

        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: selected)!, completionHandler: { data, _, error in

                if let error = error {
                    self.errorMessage.onNext(error)
                    return
                }

                guard let data = data else {
                    emitter.onCompleted()
                    return
                }

                let json = try! JSON(data: data)
                let isSuccess = json["state"].stringValue == "success"

                emitter.onNext(isSuccess)
                emitter.onCompleted()

                if !isSuccess {
                    let failMessage = json["error"].stringValue
                    let failError = NSError(domain: failMessage, code: 0, userInfo: nil)
                    self.errorMessage.onNext(failError)
                }

            })
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
        .delay(0.5, scheduler: MainScheduler.instance)
        .do(onNext: { _ in self.progressVisible.onNext(false) })
    }

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
