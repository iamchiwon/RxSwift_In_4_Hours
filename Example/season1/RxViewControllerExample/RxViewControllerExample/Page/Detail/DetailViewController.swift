//
//  DetailViewController.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import UIKit
import CWUtils
import RxSwift
import RxCocoa
import RxOptional
import RxViewController

class DetailViewController: UIViewController {

    struct Constant {
        static let avatarSize: CGFloat = 200
        static let labelFont = UIFont.systemFont(ofSize: 30)
    }

    var idLabel: UILabel!
    var avatarView: UIImageView!
    var nameLabel: UILabel!
    var jobLabel: UILabel!
    var ageLabel: UILabel!
    var likeButton: UIButton!

    let memberChangedResult = PublishRelay<LikableMember?>()

    let member = BehaviorRelay<LikableMember?>(value: nil)
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = member.value else {
            fatalError("member has not set")
        }

        setupView()
        bindView()
    }

    private func setupView() {
        title = member.value?.member.name ?? "Member Detail"
        view.backgroundColor = .white

        let scrollView = createView(UIScrollView(), parent: view, constraint: { m in
            m.edges.equalToSuperview()
        })

        let stack = createView(UIStackView(), parent: scrollView, setting: { v in
            v.axis = .vertical
        }, constraint: { m in
            m.left.equalToSuperview().offset(20)
            m.right.equalToSuperview().offset(-20)
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().offset(40)
        })

        let setFont30: (UILabel) -> Void = { v in
            v.font = Constant.labelFont
            v.textColor = .black
        }

        @discardableResult
        func wrapView<V>(_ childBuilder: (UIView) -> V) -> V {
            let parent = createView(UIView(), parent: stack)
            return childBuilder(parent)
        }

        avatarView = wrapView() { v in
            createView(UIImageView(), parent: v, setting: { v in
                v.cornerRadius = Constant.avatarSize / 2
                v.borderColor = UIColor.lightGray
                v.borderWidth = 1 / UIScreen.main.scale
                v.contentMode = .scaleAspectFill
            }, constraint: { m in
                m.width.height.equalTo(Constant.avatarSize)
                m.top.bottom.centerX.equalToSuperview()
            })
        }

        idLabel = wrapView() { v in
            createView(UILabel(), parent: v, setting: { v in
                v.font = UIFont.systemFont(ofSize: 13)
                v.textColor = UIColor.blue.withAlphaComponent(0.4)
            }, constraint: { m in
                m.right.equalToSuperview().offset(-20)
            })
        }

        (nameLabel, ageLabel) = wrapView() { v in
            let name = createView(UILabel(), parent: v, setting: { v in
                v.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            }, constraint: { m in
                m.top.equalToSuperview().offset(30)
                m.bottom.equalToSuperview()
            })

            let age = createView(UILabel(), parent: v, setting: { v in
                v.font = UIFont.systemFont(ofSize: 20, weight: .light)
            }, constraint: { m in
                m.centerY.equalTo(name)
                m.left.equalTo(name.snp.right).offset(15)
            })

            return (name, age)
        }

        jobLabel = createView(UILabel(), parent: stack, setting: { v in
            v.font = UIFont.systemFont(ofSize: 20, weight: .light)
            v.textColor = UIColor.gray
        })

        likeButton = wrapView() { v in
            createView(UIButton(), parent: v, setting: { v in
                v.titleLabel?.font = Constant.labelFont
                v.setTitleColor(.black, for: .normal)
                v.setTitleColor(.gray, for: .highlighted)
                v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            }, constraint: { m in
                m.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
                m.height.equalTo(60)
            })
        }
    }

    private func bindView() {
        member.filterNil()
            .map { $0.member }
            .subscribe(onNext: { [weak self] m in
                self?.idLabel.text = "# \(m.id)"
                self?.nameLabel.text = m.name
                self?.jobLabel.text = m.job
                self?.ageLabel.text = "(\(m.age))"
            })
            .disposed(by: disposeBag)

        member.filterNil()
            .map { $0.member }
            .map { $0.avatar.url() }
            .flatMap(UIImageView.loadImage)
            .observeOn(Schedulers.main)
            .bind(to: avatarView.rx.image)
            .disposed(by: disposeBag)

        member.filterNil()
            .map { $0.liked }
            .map { $0 ? "♥︎  unlike" : "♡  like" }
            .subscribe(onNext: { [weak self] likeMark in
                self?.likeButton.setTitle(likeMark, for: .normal)
            })
            .disposed(by: disposeBag)

        likeButton.rx.tap.asObservable()
            .withLatestFrom(member)
            .filterNil()
            .map { it in LikableMember(member: it.member, liked: !it.liked) }
            .bind(to: member)
            .disposed(by: disposeBag)

        rx.didMoveToParentViewController
            .filter({ $0 == nil })
            .take(1)
            .withLatestFrom(member)
            .bind(to: memberChangedResult)
            .disposed(by: disposeBag)
    }

    deinit {
        print("Detail ViewController had deinit")
    }
}
