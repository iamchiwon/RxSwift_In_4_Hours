//
//  ViewMenu.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 13/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import Foundation

struct ViewMenu {
    var name: String
    var price: Int
    var count: Int

    init(_ item: MenuItem) {
        name = item.name
        price = item.price
        count = 0
    }

    init(name: String, price: Int, count: Int) {
        self.name = name
        self.price = price
        self.count = count
    }

    func countUpdated(_ count: Int) -> ViewMenu {
        return ViewMenu(name: name, price: price, count: count)
    }

    func asMenuItem() -> MenuItem {
        return MenuItem(name: name, price: price)
    }
}

extension ViewMenu: Equatable {
    static func == (lhs: ViewMenu, rhs: ViewMenu) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.count == rhs.count
    }
}
