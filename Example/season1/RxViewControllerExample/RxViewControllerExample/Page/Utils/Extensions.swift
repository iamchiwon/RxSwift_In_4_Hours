//
//  Extensions.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 11/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import CWUtils
import RxCocoa
import RxSwift
import UIKit

// Cachable Image Loader
extension UIImageView {
    private static var imageCache: [URL: UIImage]?

    private static func initImageCache() {
        UIImageView.imageCache = [:]

        _ = NotificationCenter.default.rx
            .notification(UIApplication.didReceiveMemoryWarningNotification)
            .subscribe(onNext: { _ in
                UIImageView.imageCache = [:]
            })
    }

    static func loadImage(from url: URL) -> Observable<UIImage?> {
        if UIImageView.imageCache == nil { initImageCache() }

        if let cached = UIImageView.imageCache?[url] {
            return Observable.just(cached)
        }

        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                if error != nil {
                    emitter.onError(error!)
                    return
                }

                guard let data = data else {
                    emitter.onCompleted()
                    return
                }

                let image = UIImage(data: data)
                if let cachable = image {
                    UIImageView.imageCache?[url] = cachable
                }

                emitter.onNext(image)
                emitter.onCompleted()
            })

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// async image setter
extension UIImageView {
    func setImageAsync(from url: URL, default defaultImage: UIImage? = nil) -> Disposable {
        image = defaultImage
        return UIImageView.loadImage(from: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] img in
                self?.image = img
            }, onError: { [weak self] err in
                ELog(err)
                self?.image = defaultImage
            })
    }
}
