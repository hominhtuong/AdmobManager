//
//  AppDelegate.swift
//  Example
//
//  Created by Minh Tường on 07/10/2022.
//

import UIKit
import GoogleMobileAds
import AdmobManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let kEnterBackground = "kEnterBackground"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["3bee8640fd90f80580322bc31417d55b"]
        
        let configs = AdmobConfiguration()
        configs.showLog = true
        configs.frequencyCapping = 4
        configs.impressionPercentage = 100
        
        AdmobManager.shared.configs = configs
        AdmobManager.shared.loadOpenAd()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.bool(forKey: kEnterBackground) {
            AdmobManager.shared.showOpenAd()
            UserDefaults.standard.set(false, forKey: kEnterBackground)
            UserDefaults.standard.synchronize()

        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        AdmobManager.shared.loadOpenAd()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.set(true, forKey: kEnterBackground)
        UserDefaults.standard.synchronize()
    }
}

