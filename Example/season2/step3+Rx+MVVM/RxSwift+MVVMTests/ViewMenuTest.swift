//
//  ViewMenuTest.swift
//  RxSwift+MVVMTests
//
//  Created by iamchiwon on 13/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import XCTest

class ViewMenuTest: XCTestCase {
    func testMenuItemToViewMenu() {
        let menuItems = [
            MenuItem(name: "A", price: 100),
            MenuItem(name: "B", price: 200),
        ]
        let viewMenuItems = [
            ViewMenu(name: "A", price: 100, count: 0),
            ViewMenu(name: "B", price: 200, count: 0),
        ]

        let viewMenus = menuItems.map { ViewMenu($0) }
        XCTAssertEqual(viewMenuItems, viewMenus)

        let menus = viewMenus.map { $0.asMenuItem() }
        XCTAssertEqual(menuItems, menus)
    }
}
