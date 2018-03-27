//
//  AppDelegate.swift
//  DeadStick
//
//  Created by Hal W. Dale, Jr. on 11/17/17.
//  Copyright © 2017 Hal W. Dale, Jr. All rights reserved.
//

import UIKit

@UIApplicationMain
// Begin class definition.
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarViewController = self.window!.rootViewController as! UITabBarController
        print(tabBarViewController.viewControllers?.count ?? 0)
        var splitViewController:UISplitViewController? = nil
        for viewController in tabBarViewController.viewControllers! {
            if viewController.title == "Master" {
                splitViewController = viewController as? UISplitViewController
            }
        }
        
        let navigationController = splitViewController!.viewControllers[splitViewController!.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        splitViewController!.delegate = self
        return true
    }
    
    // Use this method to pause ongoing tasks.
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    // Use this method to release shared resources.
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    // Called to transition from background to active state.
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
    // MARK: - Split view
    
    // Remove the secondary view when going to another view.
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else {return false}
        if topAsDetailController.deadstick == nil {
            return true
        }
        return false
    }
    // End class definition.
}

