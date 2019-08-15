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
    static let identifier = "OrderViewController"

    var viewModel: OrderViewModelType
    var disposeBag = DisposeBag()

    // MARK: - Life Cycle

    init(viewModel: OrderViewModelType = OrderViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = OrderViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - UI Binding

    func setupBindings() {
        Observable.merge([
            rx.viewWillAppear.take(1).map { _ in false },
            rx.viewWillAppear.take(1).map { _ in true },
        ])
            .subscribe(onNext: { [weak navigationController] visible in
                navigationController?.isNavigationBarHidden = visible
            })
            .disposed(by: disposeBag)

        ordersList.rx.text.orEmpty
            .distinctUntilChanged()
            .map { [weak self] _ in self?.ordersList.calcHeight() ?? 0 }
            .bind(to: ordersListHeight.rx.constant)
            .disposed(by: disposeBag)

        viewModel.orderedList
            .bind(to: ordersList.rx.text)
            .disposed(by: disposeBag)

        viewModel.itemsPriceText
            .bind(to: itemsPrice.rx.text)
            .disposed(by: disposeBag)

        viewModel.itemsVatText
            .bind(to: vatPrice.rx.text)
            .disposed(by: disposeBag)

        viewModel.totalPriceText
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var ordersList: UITextView!
    @IBOutlet var ordersListHeight: NSLayoutConstraint!
    @IBOutlet var itemsPrice: UILabel!
    @IBOutlet var vatPrice: UILabel!
    @IBOutlet var totalPrice: UILabel!
}
