//
//  Member.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import Foundation

struct Member : Equatable {
    let id: Int
    let name: String
    let job: String
    let age: Int
    
    let liked: Bool
}

extension Member {
    static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}
