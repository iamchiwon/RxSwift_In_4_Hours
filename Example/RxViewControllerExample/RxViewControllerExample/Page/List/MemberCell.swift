//
//  MemberCell.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import CWUtils
import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class MemberCell: UITableViewCell, Reusable {
    struct Constant {
        static let imageSize: CGFloat = 50
    }

    var avatar: UIImageView!
    var name: UILabel!
    var job: UILabel!
    var liked: UILabel!

    var disposeBag = DisposeBag()

    required init?(coder aDecoder: NSCoder) {
        fatalError("no storyboard used!")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func setupView() {
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        avatar = createView(UIImageView(), parent: self, setting: { v in
            v.cornerRadius = Constant.imageSize / 2
            v.borderColor = UIColor.lightGray
            v.borderWidth = 1 / UIScreen.main.scale
            v.contentMode = .scaleAspectFill
        }, constraint: { m in
            m.width.height.equalTo(Constant.imageSize)
            m.top.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 0))
        })

        createView(UIStackView(), parent: self, setting: { v in
            v.axis = .vertical
            v.spacing = 4
            
            self.name = createView(UILabel(), parent: v, setting: { v in
                v.font = UIFont.systemFont(ofSize: 16)
            })
            
            self.job = createView(UILabel(), parent: v, setting: { v in
                v.font = UIFont.systemFont(ofSize: 10)
                v.textColor = UIColor.lightGray
            })
            
        }, constraint: { m in
            m.left.equalTo(self.avatar.snp.right).offset(15)
            m.centerY.equalToSuperview()
        })

        liked = createView(UILabel(), parent: self, setting: { v in
            v.font = UIFont.systemFont(ofSize: 26)
            v.textColor = .red
        }, constraint: { m in
            m.right.equalToSuperview().offset(-20)
            m.centerY.equalToSuperview()
        })
    }

    func setData(_ member: LikableMember) {
        avatar.setImageAsync(from: member.member.avatar.url(), default: nil)
            .disposed(by: disposeBag)
        name.text = member.member.name
        job.text = member.member.job
        liked.text = member.liked ? "♥︎" : "♡"
        liked.textColor = member.liked ? .red : .gray
    }
}
