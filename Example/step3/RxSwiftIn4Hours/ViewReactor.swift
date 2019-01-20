//
//  ViewModel.swift
//  RxSwiftIn4Hours
//
//  Created by Song Chiwon on 20/01/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import SwiftyJSON

class ViewReactor: Reactor {
    enum Action {
        case email(String)
        case password(String)
        case login(String, String)
    }

    enum Mutation {
        case checkEmail(String)
        case checkPassword(String)
        case doLogin
        case progress(Bool)
        case error(Error?)
    }

    struct State {
        var idBulletVisible = true
        var pwBulletVisible = true
        var idValid = false
        var pwValid = false
        var loginEnable = false

        var progressVisible = false
        var errorMessage: Error? = nil
    }

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .email(email):
            return Observable.just(.checkEmail(email))

        case let .password(password):
            return Observable.just(.checkPassword(password))

        case let .login(email, password):
            return Observable.concat([
                Observable.just(Mutation.progress(true)),
                self.login(email: email, pass: password)
                    .filter { $0 }
                    .flatMap { _ in Observable.just(Mutation.doLogin) }
                    .catchError { err in Observable.just(.error(err)) },
                Observable.just(Mutation.progress(false)),
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .checkEmail(email):
            state.idValid = checkEmailValid(email)
            state.idBulletVisible = !state.idValid || email.isEmpty
            state.loginEnable = state.idValid && state.pwValid
        case let .checkPassword(password):
            state.pwValid = checkPasswordValid(password)
            state.pwBulletVisible = !state.pwValid || password.isEmpty
            state.loginEnable = state.idValid && state.pwValid
        case .doLogin:
            break
        case let .progress(progressVisible):
            state.progressVisible = progressVisible
        case let .error(err):
            state.errorMessage = err
        }
        return state
    }

    func login(email: String, pass: String) -> Observable<Bool> {
        let successUrl = "https://raw.githubusercontent.com/iamchiwon/RxSwift_In_4_Hours/master/docs/login_ok.json"
        let failUrl = "https://raw.githubusercontent.com/iamchiwon/RxSwift_In_4_Hours/master/docs/login_fail.json"

        let randomIndex = Int(arc4random() % 2)
        let selected = [successUrl, failUrl][randomIndex]

        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: selected)!, completionHandler: { data, _, error in

                if let error = error {
                    emitter.onError(error)
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
                    emitter.onError(failError)
                }

            })
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
        .delay(0.5, scheduler: MainScheduler.instance)
    }

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
