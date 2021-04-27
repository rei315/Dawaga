//
//  AppDelegate.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        }
        
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainModel = MainModel()
        let mainViewModel = MainViewModel(model: mainModel)
        let nav = UINavigationController(rootViewController: MainViewController(model: mainModel, viewModel: mainViewModel))
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

