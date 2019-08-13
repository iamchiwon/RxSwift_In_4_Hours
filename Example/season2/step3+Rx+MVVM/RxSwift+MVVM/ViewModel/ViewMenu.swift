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
}

extension ViewMenu {
    static func fromMenuItem(_ item: MenuItem) -> ViewMenu {
        return ViewMenu(name: item.name, price: item.price, count: 0)
    }

    static func toMenuItem(_ item: ViewMenu) -> MenuItem {
        return MenuItem(name: item.name, price: item.price)
    }
}

extension ViewMenu: Equatable {
    static func == (lhs: ViewMenu, rhs: ViewMenu) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.count == rhs.count
    }
}
