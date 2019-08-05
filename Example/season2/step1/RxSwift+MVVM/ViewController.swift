//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }

    // MARK: SYNC

    @IBOutlet var syncActivity: UIActivityIndicatorView!
    @IBAction func onSyncButtonTap() {
        editView.text = ""
        setVisibleWithAnimation(syncActivity, true)
        guard let url = URL(string: MEMBER_LIST_URL),
            let data = try? Data(contentsOf: url),
            let json = String(data: data, encoding: .utf8) else {
            setVisibleWithAnimation(syncActivity, false)
            return
        }
        editView.text = json
        setVisibleWithAnimation(syncActivity, false)
    }

    // MARK: ASYNC

    @IBOutlet var asyncActivity: UIActivityIndicatorView!
    @IBAction func onAsyncButtonTap() {
        editView.text = ""
        setVisibleWithAnimation(asyncActivity, true)
        DispatchQueue.global().async {
            guard let url = URL(string: MEMBER_LIST_URL),
                let data = try? Data(contentsOf: url),
                let json = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async { [weak self] in
                    self?.setVisibleWithAnimation(self?.asyncActivity, false)
                }

                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.editView.text = json
                self?.setVisibleWithAnimation(self?.asyncActivity, false)
            }
        }
    }
}
