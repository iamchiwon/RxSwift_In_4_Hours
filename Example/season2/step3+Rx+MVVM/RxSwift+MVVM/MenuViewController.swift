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
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        fetchMenuItems()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            let items = menuItems$.value.filter { $0.count > 0 }
            orderVC.orderedMenuItems.accept(items)
        }
    }

    // MARK: - UI Logic

    func setupBindings() {
        // 당겨서 새로고침
        let refreshControl = UIRefreshControl()
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: fetchMenuItems)
            .disposed(by: disposeBag)
        tableView.refreshControl = refreshControl

        // 테이블뷰 아이템들
        menuItems$
            .bind(to: tableView.rx.items(cellIdentifier: MenuItemTableViewCell.identifier,
                                         cellType: MenuItemTableViewCell.self)) {
                index, item, cell in

                cell.title.text = item.menu.name
                cell.price.text = "\(item.menu.price)"
                cell.count.text = "\(item.count)"
                cell.onCountChanged = { [weak self] inc in
                    guard let self = self else { return }
                    var count = item.count + inc
                    if count < 0 { count = 0 }

                    var menuItems = self.menuItems$.value
                    menuItems[index] = (item.menu, count)
                    self.menuItems$.accept(menuItems)
                }
            }
            .disposed(by: disposeBag)

        // 선택된 아이템 총개수
        menuItems$
            .map { $0.map { $0.count }.reduce(0, +) }
            .map { "\($0)" }
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)

        // 선택된 아이템 총가격
        menuItems$
            .map { $0.map { $0.menu.price * $0.count }.reduce(0, +) }
            .map { $0.currencyKR() }
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)

        // 처음 보일때 하고 clear 버튼 눌렀을 때
        Observable.merge([rx.viewWillAppear.map { _ in () }, clearButton.rx.tap.map { _ in () }])
            .withLatestFrom(menuItems$)
            .map { $0.map { ($0.menu, 0) } }
            .bind(to: menuItems$)
            .disposed(by: disposeBag)

        // order 버튼 눌렀을 때
        orderButton.rx.tap
            .withLatestFrom(menuItems$)
            .map { $0.map { $0.count }.reduce(0, +) }
            .do(onNext: { [weak self] allCount in
                if allCount <= 0 {
                    self?.showAlert("Order Fail", "No Orders")
                }
            })
            .filter { $0 > 0 }
            .map { _ in "OrderViewController" }
            .subscribe(onNext: { [weak self] identifier in
                self?.performSegue(withIdentifier: identifier, sender: nil)
            })
            .disposed(by: disposeBag)
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - Business Logic

    let menuItems$: BehaviorRelay<[(menu: MenuItem, count: Int)]> = BehaviorRelay(value: [])
    var disposeBag = DisposeBag()

    func fetchMenuItems() {
        activityIndicator.isHidden = false
        APIService.fetchAllMenusRx()
            .map { data in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                    throw NSError(domain: "Decoding error", code: -1, userInfo: nil)
                }
                return response.menus.map { ($0, 0) }
            }
            .observeOn(MainScheduler.instance)
            .do(onError: { [weak self] error in
                self?.showAlert("Fetch Fail", error.localizedDescription)
            }, onDispose: { [weak self] in
                self?.activityIndicator.isHidden = true
                self?.tableView.refreshControl?.endRefreshing()
            })
            .bind(to: menuItems$)
            .disposed(by: disposeBag)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var orderButton: UIButton!
}
