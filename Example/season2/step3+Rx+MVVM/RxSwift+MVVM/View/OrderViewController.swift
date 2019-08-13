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
    var viewModel: OrderViewModel!
    var disposeBag = DisposeBag()

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

        viewModel.orderedList()
            .bind(to: ordersList.rx.text)
            .disposed(by: disposeBag)

        viewModel.itemsPriceText()
            .bind(to: itemsPrice.rx.text)
            .disposed(by: disposeBag)

        viewModel.itemsVatText()
            .bind(to: vatPrice.rx.text)
            .disposed(by: disposeBag)

        viewModel.totalPriceText()
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
    }

    func heightWithConstrainedWidth(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }

    // MARK: - Interface Builder

    @IBOutlet var ordersList: UITextView!
    @IBOutlet var ordersListHeight: NSLayoutConstraint!
    @IBOutlet var itemsPrice: UILabel!
    @IBOutlet var vatPrice: UILabel!
    @IBOutlet var totalPrice: UILabel!
}
