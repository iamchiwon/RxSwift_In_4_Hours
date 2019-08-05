//
//  DetailViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class DetailViewController: UIViewController {
    var data: Member!

    @IBOutlet var avatar: UIImageView!
    @IBOutlet var id: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var job: UILabel!
    @IBOutlet var age: UILabel!

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setData(data)
    }

    func setData(_ data: Member) {
        loadImage(from: data.avatar)
            .observeOn(MainScheduler.instance)
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
        id.text = "#\(data.id)"
        avatar.image = nil
        name.text = data.name
        job.text = data.job
        age.text = "(\(data.age))"
    }

    private func makeBig(_ url: String) -> Observable<String> {
        return Observable.just(url)
            .map { $0.replacingOccurrences(of: "size=50x50&", with: "") }
    }

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
}
