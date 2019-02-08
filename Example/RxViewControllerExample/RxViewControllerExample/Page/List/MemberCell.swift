//
//  MemberCell.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import CWUtils

class MemberCell : UITableViewCell, Reusable {
    
    var name: UILabel!
    var liked: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no storyboard used!")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        name = createView(UILabel(), parent: self, setting: { v in
            v.font = UIFont.systemFont(ofSize: 16)
        }, constraint: { m in
            m.top.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            m.height.equalTo(40)
        })
        
        liked = createView(UILabel(), parent: self, setting: { v in
            v.font = UIFont.systemFont(ofSize: 20)
            v.textColor = .red
        }, constraint: { m in
            m.top.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        })
    }
    
    func setData(_ member: LikableMember) {
        name.text = member.member.name
        liked.text = member.liked ? "♥︎" : "♡"
    }
}
