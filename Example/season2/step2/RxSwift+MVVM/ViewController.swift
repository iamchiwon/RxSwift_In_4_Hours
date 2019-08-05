//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

struct Member: Decodable {
    let id: Int
    let name: String
    let avatar: String
    let job: String
    let age: Int
}

class ViewController: UITableViewController {
    var data: [Member] = []
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadMembers()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] members in
                self?.data = members
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func loadMembers() -> Observable<[Member]> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: MEMBER_LIST_URL)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                guard let data = data,
                    let members = try? JSONDecoder().decode([Member].self, from: data) else {
                    emitter.onCompleted()
                    return
                }

                emitter.onNext(members)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier,
            id == "DetailViewController",
            let detailVC = segue.destination as? DetailViewController,
            let data = sender as? Member else {
            return
        }
        detailVC.data = data
    }
}

// MARK: TableView DataSource

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberItemCell") as! MemberItemCell
        let item = data[indexPath.row]

        cell.setData(item)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        performSegue(withIdentifier: "DetailViewController", sender: item)
    }
}

// MARK: TableView Cell

class MemberItemCell: UITableViewCell {
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var job: UILabel!
    @IBOutlet var age: UILabel!

    func setData(_ data: Member) {
        loadImage(from: data.avatar)
            .observeOn(MainScheduler.instance)
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
        avatar.image = nil
        name.text = data.name
        job.text = data.job
        age.text = "(\(data.age))"
    }

    var disposeBag = DisposeBag()

    private func loadImage(from url: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                guard let data = data,
                    let image = UIImage(data: data) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }

                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
