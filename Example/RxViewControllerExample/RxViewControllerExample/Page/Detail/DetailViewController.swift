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
        static let labelFont = UIFont.systemFont(ofSize: 30)
    }
    
    var idLabel: UILabel!
    var nameLabel: UILabel!
    var jobLabel: UILabel!
    var ageLabel: UILabel!
    var likeButton: UIButton!
    
    let memberChangedResult = PublishRelay<LikableMember?>()

    let member = BehaviorRelay<LikableMember?>(value: nil)
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindView()
    }

    private func setupView() {
        title = "Detail"
        view.backgroundColor = .white
        
        let stack = createView(UIStackView(), parent: view, setting: { v in
            v.axis = .vertical
        }, constraint: { m in
            m.left.equalToSuperview().offset(20)
            m.right.equalToSuperview().offset(-20)
            m.center.equalToSuperview()
        })
        
        let setFont30 : (UILabel) -> Void = { v in
            v.font = Constant.labelFont
            v.textColor = .black
        }
        
        idLabel = createView(UILabel(), parent: stack, setting: setFont30)
        nameLabel = createView(UILabel(), parent: stack, setting: setFont30)
        jobLabel = createView(UILabel(), parent: stack, setting: setFont30)
        ageLabel = createView(UILabel(), parent: stack, setting: setFont30)
        likeButton = createView(UIButton(), parent: stack, setting: { v in
            v.titleLabel?.font = Constant.labelFont
            v.setTitleColor(.red, for: .normal)
            v.backgroundColor = .lightGray
        }, constraint: { m in
            m.height.equalTo(60)
        })
    }
    
    private func bindView() {
        member.filterNil()
            .map { $0.member }
            .subscribe(onNext: { [weak self] m in
                self?.idLabel.text = "\(m.id)"
                self?.nameLabel.text = m.name
                self?.jobLabel.text = m.job
                self?.ageLabel.text = "\(m.age)"
            })
            .disposed(by: disposeBag)
        
        member.filterNil()
            .map { $0.liked }
            .map { $0 ? "♥︎" : "♡" }
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
        
        rx.viewWillDisappear
            .take(1)
            .withLatestFrom(member)
            .bind(to: memberChangedResult)
            .disposed(by: disposeBag)
    }

    deinit {
        print("Detail ViewController had deinit")
    }
}
