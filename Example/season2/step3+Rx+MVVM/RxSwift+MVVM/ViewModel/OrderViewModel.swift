//
//  OrderViewModel.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 13/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

protocol OrderViewModelType {
    var orderedList: Observable<String> { get }
    var itemsPriceText: Observable<String> { get }
    var itemsVatText: Observable<String> { get }
    var totalPriceText: Observable<String> { get }
}

class OrderViewModel: OrderViewModelType {
    let orderedList: Observable<String>
    let itemsPriceText: Observable<String>
    let itemsVatText: Observable<String>
    let totalPriceText: Observable<String>

    init(_ selectedMenus: [ViewMenu] = []) {
        let menus = Observable.just(selectedMenus)
        let price = menus.map { $0.map { $0.price * $0.count }.reduce(0, +) }
        let vat = price.map { Int(Float($0) * 0.1 / 10 + 0.5) * 10 }

        orderedList = menus
            .map { $0.map { "\($0.name) \($0.count)개\n" }.joined() }

        itemsPriceText = price.map { $0.currencyKR() }

        itemsVatText = vat.map { $0.currencyKR() }

        totalPriceText = Observable.combineLatest(price, vat) { $0 + $1 }
            .map { $0.currencyKR() }
    }
}
