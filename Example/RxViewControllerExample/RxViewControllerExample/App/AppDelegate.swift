//
//  AppDelegate.swift
//  RxViewControllerExample
//
//  Created by iamchiwon on 09/02/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let listViewController = ListViewController()
        let navigation = UINavigationController(rootViewController: listViewController)
        
        window = UIWindow()
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }


}

