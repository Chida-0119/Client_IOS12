//
//  AppDelegate.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/13.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
 
        if !UserMaster.shared.getFromWeb() {
           UserMaster.shared.getFromCache()
        }
        
        if !CacheStore.shared.exists(fileName: "walletKey.json"){
             //windowを生成
            self.window = UIWindow(frame: UIScreen.main.bounds)
            //Storyboardを指定
            let storyboard = UIStoryboard(name: "InitialSettings", bundle: nil)
            //Viewcontrollerを指定
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "myProfileSetting")
            self.window?.rootViewController = initialViewController
            //表示
            self.window?.makeKeyAndVisible()
        }else{
            try! MyProfile.shared.load()
        }
        
        return true
    }

}

