//
//  AppDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import UserNotifications //import UserNotifications 1 local

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setLanguage(langCode: "en") // default language en
        
        
        let app = AppConfiguration()
        print("apiBaseURL", app.apiBaseURL, "\n", "apiKey", app.apiKey, "\n","bundleID", app.bundleID)
        
        
        
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
               if granted {
                   DispatchQueue.main.async {
                       UIApplication.shared.registerForRemoteNotifications()
                   }
               } else {
                   print("Permission for push notifications denied.")
               }
           }
        
        
        
        

        
        setupTitleNavigationBar()
//        configureNotification()  // push notification 2 local
        print("didFinishLaunchingWithOptions") //AIzaSyBApx6bA_YNHU8zL_XBrpSI10wol9EBVsA
        return true
    }
    
  

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("configurationForConnecting")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("didDiscardSceneSessions")
    }
    
}



extension AppDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // Handle the notification and perform necessary actions
//        completionHandler()
//    }
    
    
    
}



//MARK: Handle navigation contoller
extension AppDelegate{
    
    func setupTitleNavigationBar( font: UIFont? = UIFont.systemFont(ofSize: 17, weight: .regular),
                                         titleColor: UIColor = .white  ){
        
        let titleAttribute = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: titleColor
        ]
       
       let appearance = UINavigationBarAppearance()
       appearance.configureWithOpaqueBackground()
       appearance.shadowColor = .mainBlueColor

       appearance.backgroundColor = .mainBlueColor
       appearance.titleTextAttributes = titleAttribute as [NSAttributedString.Key : Any]
        
        
        
       UINavigationBar.appearance().standardAppearance = appearance
       UINavigationBar.appearance().scrollEdgeAppearance = appearance
       UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().backItem?.title = ""

 
    }
}




//firebase //https://github.com/firebase/firebase-ios-sdk


//MARK: Setup Push Notification Local
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    
    
    private func configureNotification(){
        // Request user authorization for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            granted ? print("User granted authorization") :  print("User denied authorization")
        }
        // Set the delegate for UNUserNotificationCenter
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    // Handle the display of notifications while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Customize the presentation options as needed
        completionHandler([.alert, .sound])
    }
    
    // Handle the user's response to the notification (e.g., tapping on it) tapped on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the response as needed
        // Handle the notification response here
        let userInfo = response.notification.request.content.userInfo
        
        print("userInfo: \(userInfo)")

        // Get the current view controller
        guard let window = UIApplication.shared.keyWindow,
              let rootViewController = window.rootViewController else {
            completionHandler()
            return
        }
        
        // Create an instance of the target view controller
        let targetViewController = UIViewController()
        targetViewController.view.backgroundColor = .orange
        
        // Push the target view controller onto the navigation stack
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(targetViewController, animated: false)
        } else {
            let navigationController = UINavigationController(rootViewController: targetViewController)
            window.rootViewController = navigationController
        }
        
        // Call the completion handler when you're done processing the notification
        completionHandler()
        
    }
}
