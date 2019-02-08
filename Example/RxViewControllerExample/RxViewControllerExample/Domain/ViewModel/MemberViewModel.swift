//
//  MemberViewModel.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import CWUtils
import Foundation
import RxSwift

class MemberViewModel {
    let members = BehaviorSubject<[Member]>(value: [])

    func fetch() {
        executeMainAsync {
            let data = Array(1 ... 100).map { i in
                Member(id: i, name: "Name\(i)", job: "job\(i)", age: 20 + (i % 20), liked: false)
            }
            self.members.onNext(data)
        }
    }
    
    func update(_ member: Member) {
        do {
            
            let updated = try members.value().map { it -> Member in
                guard it.id == member.id else { return it }
                return member
            }
            members.onNext(updated)
            
        } catch let error {
            ELog(error)
        }
    }

    func like(_ id: Int) {
        updateLiked(id, to: true)
    }
    
    func unlike(_ id: Int) {
        updateLiked(id, to: false)
    }
    
    private func updateLiked(_ id: Int, to liked: Bool) {
        do {
            
            let updated = try members.value().map { it -> Member in
                guard it.id == id else { return it }
                return Member(id: it.id, name: it.name, job: it.job, age: it.age, liked: liked)
            }
            members.onNext(updated)
            
        } catch let error {
            ELog(error)
        }
    }
}
