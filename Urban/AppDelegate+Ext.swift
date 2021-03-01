//
//  AppDelegate+Ext.swift
//  Urban
//
//  Created by shakhzodurinboev on 5/11/20.
//  Copyright © 2020 GlobalSolutions. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
           let main = UIStoryboard(name: "Main", bundle: nil)
           ///////Check user is logged or not
           if let userIsLogged = UserDefaults.standard.object(forKey: "UserIsLogged") {
               if userIsLogged as! Bool == true {
                   let tabBar = main.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                   window?.rootViewController?.addChild(tabBar)
                   print(shortcutItem.type)
                   if shortcutItem.type == "com.globalsolutions.obse.Feeds" {
                       TabBarViewController.tabBarId = 0
                   } else if shortcutItem.type == "com.globalsolutions.obse.QR" {
                       TabBarViewController.tabBarId = 1
                       BarAndQRCodeViewController.selectedSegment = 0
                   } else {
                       TabBarViewController.tabBarId = 1
                       BarAndQRCodeViewController.selectedSegment = 1
                   }
               } else {
                   let logIn = main.instantiateViewController(withIdentifier: "LogInNavController")
                   window?.rootViewController?.addChild(logIn)
               }
           } else {
               let logIn = main.instantiateViewController(withIdentifier: "LogInNavController")
               window?.rootViewController?.addChild(logIn)
           }
       }
}
