//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Talita Groppo on 24/01/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var uniqueKey: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ConnectNetwork.shared.startMonitoring()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

