//
//  ListViewController.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CWUtils
import RxOptional

class ListViewController: UIViewController {

    var tableView: UITableView!

    let viewModel = MemberViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindView()

        viewModel.fetch()
    }

    private func setupView() {
        title = "List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = .white

        tableView = createView(UITableView(), parent: view, setting: { v in
            v.estimatedRowHeight = 40
            v.rowHeight = UITableView.automaticDimension
            v.register(cellType: MemberCell.self)
        }, constraint: { m in
            m.edges.equalToSuperview()
        })
    }

    private func bindView() {
        viewModel.members.bind(to: tableView.rx.items(cellType: MemberCell.self)) { _, data, cell in
            cell.setData(data)
        }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .map { $0.row }
            .withLatestFrom(viewModel.members, resultSelector: { $1[$0] })
            .flatMap(goDetailPage)
            .subscribe(onNext: viewModel.update)
            .disposed(by: disposeBag)
    }

    private func goDetailPage(_ member: Member) -> Observable<Member> {
        let detail = DetailViewController()
        detail.member.accept(member)
        navigationController?.pushViewController(detail, animated: true)

        return detail.memberChangedResult
            .filterNil()
            .filter { $0.liked != member.liked }
    }
}
