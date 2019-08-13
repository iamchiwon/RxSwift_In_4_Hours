//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import UIKit

class MenuViewController: UIViewController {
    let viewModel = MenuViewModel()
    var disposeBag = DisposeBag()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            let orderViewModel = OrderViewModel()
            orderVC.viewModel = orderViewModel

            viewModel
                .allSelectedMenus()
                .bind(to: orderViewModel.selectedMenus)
                .disposed(by: disposeBag)
        }
    }

    // MARK: - UI Binding

    func setupBindings() {
        // 당겨서 새로고침
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: viewModel.fetchMenu)
            .disposed(by: disposeBag)

        // 테이블뷰 아이템들
        viewModel.allMenus()
            .bind(to: tableView.rx.items(cellIdentifier: MenuItemTableViewCell.identifier,
                                         cellType: MenuItemTableViewCell.self)) {
                index, item, cell in

                cell.setData(item)
                cell.onCountChanged = { [weak self] inc in
                    self?.viewModel.increaseMenuCount(index: index, increasement: inc)
                }
            }
            .disposed(by: disposeBag)

        // 선택된 아이템 총개수
        viewModel.totalSelectedItemsCount()
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)

        // 선택된 아이템 총가격
        viewModel.totalPrice()
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)

        // 처음 보일때 하고 clear 버튼 눌렀을 때
        let viewDidAppear = rx.viewWillAppear.map { _ in () }
        let whenClearTap = clearButton.rx.tap.map { _ in () }
        Observable.merge([viewDidAppear, whenClearTap])
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.clearSelections()
            })
            .disposed(by: disposeBag)

        // order 버튼 눌렀을 때
        orderButton.rx.tap
            .flatMap(viewModel.orderMenus)
            .subscribe(onNext: { [weak self] identifier in
                self?.performSegue(withIdentifier: identifier, sender: nil)
            })
            .disposed(by: disposeBag)

        // 에러 처리
        viewModel.errors()
            .subscribe(onNext: { [weak self] err in
                let error = err as NSError
                self?.showAlert("Order Fail", error.domain)
            })
            .disposed(by: disposeBag)

        // 액티비티 인디케이터
        viewModel.isActivating()
            .map { !$0 }
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isActivating()
            .filter { !$0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var orderButton: UIButton!
}
