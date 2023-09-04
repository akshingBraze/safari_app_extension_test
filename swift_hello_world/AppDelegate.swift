//
//  AppDelegate.swift
//  swift_hello_world
//
//  Created by Akshin Goswami on 13/8/2023.
//

import UIKit
import BrazeKit

class AppDelegate: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    static var braze: Braze? = nil
    
    // on launch
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // confiure Braze
        let configuration = Braze.Configuration(
            apiKey: "a860c197-2a20-4d19-9d58-daa64f9e7692",
            endpoint: "sdk.iad-03.braze.com"
        )
        
        // automatic push confiuration
        configuration.push.automation = true
        let braze = Braze(configuration: configuration)
        
        AppDelegate.braze = braze
        AppDelegate.braze?.changeUser(userId: "6633a2c0-d473-423e-968c-35339ac0266f")
        AppDelegate.braze?.requestImmediateDataFlush()
        
        // register for push notifcations with APNS
        application.registerForRemoteNotifications()        // ask for push notifications
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories(Braze.Notifications.categories)
        center.delegate = self
        var options: UNAuthorizationOptions = [.alert, .sound, .badge]
        if #available(iOS 12.0, *) {
          options = UNAuthorizationOptions(rawValue: options.rawValue | UNAuthorizationOptions.provisional.rawValue)
        }
        center.requestAuthorization(options: options) { granted, error in
          print("Notification authorization, granted: \(granted), error: \(String(describing: error))")
        }
        
        // subscribe to push updates
        // This subscription is maintained through a Braze cancellable, which will observe for changes until the subscription is cancelled.
        // You must keep a strong reference to the cancellable to keep the subscription active.
        // The subscription is canceled either when the cancellable is deinitialized or when you call its `.cancel()` method.
        let cancellable = AppDelegate.braze?.notifications.subscribeToUpdates { payload in
          print("Braze processed notification with title '\(payload.title)' and body '\(payload.body)'")
        }
        
        print("Application Did Finish Launching")
        return true
    }
    
    // register for token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Braze SDK flushing tokens into Braze
        AppDelegate.braze?.notifications.register(deviceToken: deviceToken)
        print("deviceToken: ", deviceToken)
    }
    
    // push handler
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let braze = AppDelegate.braze, braze.notifications.handleBackgroundNotification(
          userInfo: userInfo,
          fetchCompletionHandler: completionHandler
        ) {
          return
        }
        completionHandler(.noData)
    }
    
    // part of enabling push handling in the background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let braze = AppDelegate.braze, braze.notifications.handleUserNotification(
          response: response,
          withCompletionHandler: completionHandler
        ) {
          return
        }
        completionHandler()
    }
    
    // foreground push handling
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            if #available(iOS 14.0, *) {
                completionHandler([.list, .banner])
            } else {
                completionHandler([.alert])
            }
        }
        
    }
    
    
}
