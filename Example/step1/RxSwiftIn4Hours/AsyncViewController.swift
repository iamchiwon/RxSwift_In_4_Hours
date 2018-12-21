//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController {
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

    @IBAction func onLoadSync(_ sender: Any) {
        guard let url = URL(string: loadingImageUrl) else { return }
        guard let data = try? Data(contentsOf: url) else { return }

        let image = UIImage(data: data)
        imageView.image = image
    }

    @IBAction func onLoadAsync(_ sender: Any) {
        DispatchQueue.global().async {
            guard let url = URL(string: loadingImageUrl) else { return }
            guard let data = try? Data(contentsOf: url) else { return }

            let image = UIImage(data: data)

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
