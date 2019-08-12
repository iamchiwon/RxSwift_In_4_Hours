//
//  OrderViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 07/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import UIKit

class OrderViewController: UIViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - UI Logic

    func setupBindings() {
        rx.viewWillAppear
            .take(1)
            .subscribe(onNext: { [weak navigationController] _ in
                navigationController?.isNavigationBarHidden = false
            })
            .disposed(by: disposeBag)

        rx.viewWillDisappear
            .take(1)
            .subscribe(onNext: { [weak navigationController] _ in
                navigationController?.isNavigationBarHidden = true
            })
            .disposed(by: disposeBag)

        ordersList.rx.text.orEmpty
            .map { [weak self] text in
                let width = self?.ordersList.bounds.width ?? 0
                let font = self?.ordersList.font ?? UIFont.systemFont(ofSize: 20)
                let height = self?.heightWithConstrainedWidth(text: text, width: width, font: font)
                return height ?? 0
            }
            .bind(to: ordersListHeight.rx.constant)
            .disposed(by: disposeBag)

        orderedMenuItems
            .map { $0.map { "\($0.menu.name) \($0.count)개" }.joined(separator: "\n") }
            .bind(to: ordersList.rx.text)
            .disposed(by: disposeBag)

        let itemsPriceAndVat = orderedMenuItems
            .map { items in
                items.map { $0.menu.price * $0.count }.reduce(0, +)
            }
            .map { (price: Int) -> (price: Int, vat: Int) in
                (price, Int(Float(price) * 0.1 / 10 + 0.5) * 10)
            }
            .share(replay: 1, scope: .whileConnected)

        itemsPriceAndVat
            .map { $0.price.currencyKR() }
            .bind(to: itemsPrice.rx.text)
            .disposed(by: disposeBag)

        itemsPriceAndVat
            .map { $0.vat.currencyKR() }
            .bind(to: vatPrice.rx.text)
            .disposed(by: disposeBag)

        itemsPriceAndVat
            .map { $0.price + $0.vat }
            .map { $0.currencyKR() }
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
        
        orderedMenuItems.accept(orderedMenuItems.value)
    }

    func heightWithConstrainedWidth(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }

    // MARK: - Business Logic

    var disposeBag = DisposeBag()
    let orderedMenuItems: BehaviorRelay<[(menu: MenuItem, count: Int)]> = BehaviorRelay(value: [])

    // MARK: - Interface Builder

    @IBOutlet var ordersList: UITextView!
    @IBOutlet var ordersListHeight: NSLayoutConstraint!
    @IBOutlet var itemsPrice: UILabel!
    @IBOutlet var vatPrice: UILabel!
    @IBOutlet var totalPrice: UILabel!
}
