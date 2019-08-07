//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewPullToRefresh()

        fetchMenuItems()
        updateTotalInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onClear()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            orderVC.orderedMenuItems = menuItems.filter { $0.count > 0 }
        }
    }

    // MARK: - UI Logic

    func setupTableViewPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func onRefresh() {
        fetchMenuItems()
    }

    // MARK: - Business Logic

    var menuItems: [(menu: MenuItem, count: Int)] = []

    func fetchMenuItems() {
        activityIndicator.isHidden = false
        APIService.fetchAllMenus { [weak self] result in
            switch result {
            case let .failure(err):
                self?.showAlert("Fetch Fail", err.localizedDescription)
                DispatchQueue.main.async {
                    self?.activityIndicator.isHidden = true
                    self?.tableView.refreshControl?.endRefreshing()
                }

            case let .success(data):
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                    self?.showAlert("Data Fail", "Decoding error")
                    DispatchQueue.main.async {
                        self?.activityIndicator.isHidden = true
                        self?.tableView.refreshControl?.endRefreshing()
                    }
                    return
                }
                self?.menuItems = response.menus.map { ($0, 0) }

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.updateTotalInfo()
                    self?.activityIndicator.isHidden = true
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }

    func updateTotalInfo() {
        let allCount = menuItems.map { $0.count }.reduce(0, +)
        let allPrice = menuItems.map { $0.menu.price * $0.count }.reduce(0, +)
        itemCountLabel.text = "\(allCount)"
        totalPrice.text = allPrice.currencyKR()
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

    @IBAction func onClear() {
        menuItems = menuItems.map { ($0.menu, 0) }
        tableView.reloadData()
        updateTotalInfo()
    }

    @IBAction func onOrder(_ sender: UIButton) {
        let allCount = menuItems.map { $0.count }.reduce(0, +)
        guard allCount > 0 else {
            showAlert("Order Fail", "No Orders")
            return
        }
        performSegue(withIdentifier: "OrderViewController", sender: nil)
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
        let item = menuItems[indexPath.row]

        cell.title.text = item.menu.name
        cell.price.text = "\(item.menu.price)"
        cell.count.text = "\(item.count)"
        cell.onCountChanged = { [weak self] inc in
            guard let self = self else { return }
            var count = item.count + inc
            if count < 0 { count = 0 }
            self.menuItems[indexPath.row] = (item.menu, count)

            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()

            self.updateTotalInfo()
        }

        return cell
    }
}
