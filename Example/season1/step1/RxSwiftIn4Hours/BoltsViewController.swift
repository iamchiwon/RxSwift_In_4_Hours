//
//  BoltsViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import BoltsSwift
import UIKit

class BoltsViewController: UIViewController {
    // MARK: - Field

    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }

    // MARK: - IBOutlet

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var countLabel: UILabel!

    // MARK: - IBAction

    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil

        boltsLoadImage(from: LARGER_IMAGE_URL)
            .continueWith(continuation: { task in
                DispatchQueue.main.async {
                    let image = task.result
                    self.imageView.image = image
                }
            })
    }

    // MARK: - Bolts

    func boltsLoadImage(from imageUrl: String) -> Task<UIImage> {
        let taskCompletionSource = TaskCompletionSource<UIImage>()
        asyncLoadImage(from: imageUrl, completed: { image in
            guard let image = image else {
                taskCompletionSource.cancel()
                return
            }
            taskCompletionSource.set(result: image)
        })
        return taskCompletionSource.task
    }
}
