//
//  Member.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import Foundation

struct Member : Equatable, Codable {
    let id: Int
    let name: String
    let avatar: String
    let job: String
    let age: Int
}

extension Member {
    static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}
