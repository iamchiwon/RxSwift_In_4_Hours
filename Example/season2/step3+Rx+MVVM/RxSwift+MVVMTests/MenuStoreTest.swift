//
//  RxSwift_MVVMTests.swift
//  RxSwift+MVVMTests
//
//  Created by iamchiwon on 13/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxBlocking
import RxSwift
import XCTest

class APIService {
    static func fetchAllMenusRx() -> Observable<Data> {
        let json = """
        {
        "menus": [
        { "name":"A", "price":100},
        { "name":"B", "price":200},
        ]
        }
        """
        return Observable.just(json.data(using: .utf8) ?? Data())
    }
}

class MenuStoreTest: XCTestCase {
    var domain: MenuStore!

    override func setUp() {
        domain = MenuStore()
    }

    func testFetching() {
        let expected: [MenuItem] = [
            MenuItem(name: "A", price: 100),
            MenuItem(name: "B", price: 200),
        ]
        let menuItems: [MenuItem] = try! domain.fetchMenus().toBlocking().first()!
        XCTAssertEqual(expected, menuItems)
    }
}
