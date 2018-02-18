//
//  AppDelegate.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import HoundifySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Hound.setClientID("sN4GmVrWyAcU51QIsT9fsw==")
        Hound.setClientID("4myL5EcMiCXeLX1xWsE2cQ==")
        //Hound.setClientKey("fqs_hV0T2V4fSAbtp0dbS62RTkGTqF_CBkDG1Pyy5_EUqpvAcVDvElE_rzM02REsVsQpTrqYSS8RXyE_Zc5Pwg==")
        Hound.setClientKey("dGMEBZC2O606m0ZolSB8BtS0uELTT-BrdDWpyb_Ga1Qbr1gkesWBShf-jcSFs8mNY8g_9mzapjgZFayAVrZipw==")
        
        UINavigationBar.appearance().tintColor = UIColor.clear
        UINavigationBar.appearance().setBackgroundImage(#imageLiteral(resourceName: "Groupfdasf").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 85, 0), resizingMode: .stretch), for: .default)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

