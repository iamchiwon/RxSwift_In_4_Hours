//
//  MenuViewModel.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 13/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class MenuViewModel {
    var disposeBag = DisposeBag()
    var domain: MenuFetchable = MenuStore()

    private let menuItems: BehaviorRelay<[ViewMenu]> = BehaviorRelay(value: [])
    private let activityIndicatorVisible = BehaviorRelay(value: false)
    private let errorMessage = PublishRelay<Error>()

    func viewDidLoad() {
        fetchMenu()
    }

    func fetchMenu() {
        domain.fetchMenus()
            .map { $0.map { ViewMenu.fromMenuItem($0) } }
            .do(onSubscribed: { [weak self] in
                self?.activityIndicatorVisible.accept(true)
            })
            .do(onDispose: { [weak self] in
                self?.activityIndicatorVisible.accept(false)
            })
            .bind(to: menuItems)
            .disposed(by: disposeBag)
    }

    func allMenus() -> Observable<[ViewMenu]> {
        return menuItems.asObservable()
    }

    func isActivating() -> Observable<Bool> {
        return activityIndicatorVisible.asObservable()
    }

    func errors() -> Observable<Error> {
        return errorMessage.asObservable()
    }

    func totalSelectedItemsCount() -> Observable<String> {
        return menuItems
            .map { $0.map { $0.count }.reduce(0, +) }
            .map { "\($0)" }
    }

    func totalPrice() -> Observable<String> {
        return menuItems
            .map { $0.map { $0.price * $0.count }.reduce(0, +) }
            .map { $0.currencyKR() }
    }

    func clearSelections() {
        let menus = menuItems.value
        let cleanMenu = menus.map { ViewMenu(name: $0.name, price: $0.price, count: 0) }
        menuItems.accept(cleanMenu)
    }

    func orderMenus() -> Observable<String> {
        let currentItems = menuItems.value
        return Observable.just(currentItems)
            .map { $0.map { $0.count }.reduce(0, +) }
            .map { [weak self] in
                guard $0 > 0 else {
                    let err = NSError(domain: "No Orders", code: -1, userInfo: nil)
                    self?.errorMessage.accept(err)
                    return ""
                }
                // segue identifier
                return "OrderViewController"
            }
            .filter { !$0.isEmpty }
    }

    func increaseMenuCount(index: Int, increasement: Int) {
        var menus = menuItems.value
        menus[index].count = max(menus[index].count + increasement, 0)
        menuItems.accept(menus)
    }

    func allSelectedMenus() -> Observable<[ViewMenu]> {
        let selected = menuItems.value.filter { $0.count > 0 }
        return Observable.just(selected)
    }
}
