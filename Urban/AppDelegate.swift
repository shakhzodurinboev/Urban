//
//  AppDelegate.swift
//  Urban
//
//  Created by Khusan on 29.12.2017.
//  Copyright © 2017 GlobalSolutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import GoogleSignIn
import FBSDKLoginKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_idd"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        L012Localizer.DoTheSwizzling()
        IQKeyboardManager.shared.enable = true
        ImageCache.default.maxDiskCacheSize = 100 * 1024 * 1024
        ImageCache.default.maxCachePeriodInSecond = 60 * 60 * 24 * 3
        UINavigationBar.appearance().tintColor = UIColor(red: 236.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if UserDefaults.standard.object(forKey: "AppLang") == nil { UserDefaults.standard.set("rus", forKey: "AppLang") }
       
        if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
              UNUserNotificationCenter.current().delegate = self

              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            } else {
              let settings: UIUserNotificationSettings =
              UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
            }

            Messaging.messaging().delegate = self
            application.registerForRemoteNotifications()

            
            FirebaseApp.configure()
         GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
       return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
         // If you are receiving a notification message while your app is in the background,
         // this callback will not be fired till the user taps on the notification launching the application.
         // TODO: Handle data of notification

         // With swizzling disabled you must let Messaging know about the message, for Analytics
         // Messaging.messaging().appDidReceiveMessage(userInfo)

         // Print message ID.
         if let messageID = userInfo[gcmMessageIDKey] {
           print("Message ID: \(messageID)")
         }

         // Print full message.
         print(userInfo)
       }

       func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         // If you are receiving a notification message while your app is in the background,
         // this callback will not be fired till the user taps on the notification launching the application.
         // TODO: Handle data of notification

         // With swizzling disabled you must let Messaging know about the message, for Analytics
         // Messaging.messaging().appDidReceiveMessage(userInfo)

         // Print message ID.
         if let messageID = userInfo[gcmMessageIDKey] {
           print("Message ID: \(messageID)")
         }

         // Print full message.
         print(userInfo)

         completionHandler(UIBackgroundFetchResult.newData)
       }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            let googleDidHandle = GIDSignIn.sharedInstance().handle(url)
            return googleDidHandle
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Message Data",remoteMessage.appData)
    }
}
