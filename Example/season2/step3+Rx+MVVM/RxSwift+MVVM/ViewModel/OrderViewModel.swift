//
//  OrderViewModel.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 13/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class OrderViewModel {
    var disposeBag = DisposeBag()

    let selectedMenus = BehaviorRelay<[ViewMenu]>(value: [])

    func orderedList() -> Observable<String> {
        return selectedMenus
            .map {
                $0.map { "\($0.name) \($0.count)개\n" }.joined()
            }
    }

    func itemsPrice() -> Observable<Int> {
        return selectedMenus
            .map { $0.map { $0.price * $0.count }.reduce(0, +) }
    }

    func itemsPriceText() -> Observable<String> {
        return itemsPrice()
            .map { $0.currencyKR() }
    }

    func itemsVat() -> Observable<Int> {
        return itemsPrice()
            .map { Int(Float($0) * 0.1 / 10 + 0.5) * 10 }
    }

    func itemsVatText() -> Observable<String> {
        return itemsVat()
            .map { $0.currencyKR() }
    }

    func totalPriceText() -> Observable<String> {
        return Observable.combineLatest(itemsPrice(), itemsVat()) { $0 + $1 }
            .map { $0.currencyKR() }
    }
}
