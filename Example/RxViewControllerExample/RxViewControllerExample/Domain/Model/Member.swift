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
    let job: String
    let age: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case age
    }
}

extension Member {
    static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}
