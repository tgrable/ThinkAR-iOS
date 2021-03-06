//
//  AppDelegate.swift
//  thINK
//
//  Created by Trekk mini-1 on 9/20/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var partners: PartnerData?
    var partnerData = [Partner]()
    var screenWidth = 0
    var screenHeight = 0
    var currentUnityController: UnityAppController!
    var think2016: Think2016?
    var aboutThink: AboutThink?
    var contactThink: ContactThink?
    var downloadMarker: DownloadMarker?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        currentUnityController = UnityAppController()
        currentUnityController.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Partners
        partners = PartnerData()
        partners!.detectInitialLoad() {
            (result: Bool) in
            reloadPartnerData()
        }
        // Set the screen size
        let screenSize: CGRect = UIScreen.main.bounds
        screenWidth = Int(screenSize.width)
        screenHeight = Int(screenSize.height)

        // Setup custom objects to be used throughout the application
        think2016 = Think2016()
        aboutThink = AboutThink()
        contactThink = ContactThink()
        downloadMarker = DownloadMarker()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        currentUnityController.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        currentUnityController.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        currentUnityController.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        currentUnityController.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        currentUnityController.applicationWillTerminate(application)
    }
    
    func reloadPartnerData() {
        
        partnerData = partners!.getAllPartnerObjects()
    }
    
    func startUnity() {
        currentUnityController.applicationDidBecomeActive(UIApplication.shared)
    }
    
    func pauseUnity() {
        currentUnityController.applicationWillEnterForeground(UIApplication.shared)
    }
    
    func soundOn(flag: Bool) {
        
        if flag {
            // Turn sound on
            currentUnityController.unitySound(onOff: true)
            
        } else {
            // Turn sound off
            currentUnityController.unitySound(onOff: false)
        }
    }

}
