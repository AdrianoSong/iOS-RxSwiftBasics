//
//  AppDelegate.swift
//  RxSwiftPractices
//
//  Created by Song on 14/05/20.
//  Copyright © 2020 Adriano Song. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
        window = DebugWindow(frame: UIScreen.main.bounds)
        #else
        window = UIWindow()
        #endif

        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(window: window)
        (window as? DebugWindow)?.appCoordinator = appCoordinator
        appCoordinator?.start()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }
}
