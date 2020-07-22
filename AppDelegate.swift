//
//  AppDelegate.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/7/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GooglePlaces
import MapKit
import IQKeyboardManagerSwift
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var group: Group?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()

        GMSPlacesClient.provideAPIKey("AIzaSyCsmSQw5se9JjsrQ6XI6tcsOOG1UNxzvqY")
                
        // Customize the UI of GMSAutocompleteViewController
        // Set some colors (colorLiteral is convenient)
        let barColor: UIColor =  _ColorLiteralType(red: 0, green: 0, blue: 0, alpha: 1)
        let backgroundColor: UIColor =  _ColorLiteralType(red: 0, green: 0, blue: 0, alpha: 1)
        let textColor: UIColor =  _ColorLiteralType(red: 100, green: 100, blue: 100, alpha: 1)
        // Navigation bar background.
          UINavigationBar.appearance().barTintColor = barColor
          UINavigationBar.appearance().tintColor = UIColor.white
        // Color and font of typed text in the search bar.
          let searchBarTextAttributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 16)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes as [NSAttributedString.Key : Any]
        // Color of the placeholder text in the search bar prior to text entry
          let placeholderAttributes = [NSAttributedString.Key.foregroundColor: backgroundColor, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15)]
        // Color of the default search text.
          let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes as [NSAttributedString.Key : Any])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
        
        registerForPushNotifications()

        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]

          // 1
        if let notification = notificationOption as? [String: AnyObject],
          let aps = notification["aps"] as? [String: AnyObject] {

          // 2
          //StatusNotificationItem.makeNewsItem(aps)

          // 3
          (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }
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
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
              
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }

    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }

      }
    }
    
   
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }

    func application(
      _ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
      fetchCompletionHandler completionHandler:
      @escaping (UIBackgroundFetchResult) -> Void
    ) {
      guard let aps = userInfo["aps"] as? [String: AnyObject] else {
        completionHandler(.failed)
        return
      }
      //StatusNotificationItem.makeNewsItem(aps)
    }

}

