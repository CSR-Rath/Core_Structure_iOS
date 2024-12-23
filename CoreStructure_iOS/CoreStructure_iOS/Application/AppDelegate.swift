//
//  AppDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import UserNotifications //import UserNotifications 1 local
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setLanguage(langCode: "en") // default language en
        handleConfigurationRealmSwift()
        

        //MARK: - Handle font navigation bar
    
        
        handleNavicationTitle() // title navigation bar
        configureNotification()  // push notification 2 local
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


// MARK: - HAndle Deep Line
extension AppDelegate{
    
   
    private func handleIncomingURL(_ url: URL) {
        // Parse the URL and navigate accordingly
        let urlString = url.absoluteString
        print("Received URL: \(urlString)")

        // Example: Handle a specific path
        if urlString.contains("some/path") {
            // Navigate to the specific view controller
            // You can use a NotificationCenter or a delegate to inform your view controller
        }
    }

    
    
}



//MARK: Handle navigation contoller
extension AppDelegate{
    
    
    private func handleNavicationTitle(){
        let font = UIFont.systemFont(ofSize: 18, weight: .medium)
         
         let titleAttribute = [
             NSAttributedString.Key.font: font,
             NSAttributedString.Key.foregroundColor: UIColor.white
             
         ]

        UINavigationBarAppearance().titleTextAttributes = titleAttribute as [NSAttributedString.Key : Any]
        
    }
    
   private func setupTitleNavigationBar(font: UIFont? = UIFont.systemFont(ofSize: 17, weight: .regular),
                                 titleColor: UIColor = .white){
        
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
//        completionHandler([.alert, .sound])
        
        let userInfo = notification.request.content.userInfo
        
        print("userInfo ==> \(userInfo)")
        
        
        completionHandler([.alert, .sound, .badge])
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
        
        let targetViewController = UIViewController()
        targetViewController.view.backgroundColor = .white
      
        
        // Push the target view controller onto the navigation stack
        if let navigationController = rootViewController as? UINavigationController {
            
            print("navigationController ===>")
            navigationController.pushViewController(targetViewController, animated: false)
      
        } else {
            
            print("else navigationController ===>")
            let navigationController = UINavigationController(rootViewController: targetViewController)
            window.rootViewController = navigationController
        }
        
        // Call the completion handler when you're done processing the notification
        completionHandler()
        
    }
}


var config: Realm.Configuration!
var realm: Realm!

func handleConfigurationRealmSwift(){

    let servion: UInt64 = 114
       config = Realm.Configuration(
          schemaVersion: servion,
          migrationBlock: { migration, oldSchemaVersion in
              
              switch oldSchemaVersion{
                  
              case 0..<2:
                  
                 break
              case 2..<3:
                  
                 break
              case 3..<4:
                  
                 break
              default:
                  break
              }
          }
      )
      
      Realm.Configuration.defaultConfiguration = config

    do {
        realm = try Realm(configuration: config)
        print("Realm file location: \(realm.configuration.fileURL?.path ?? "Unknown")")
    } catch {
        print("Error initializing Realm: \(error.localizedDescription)")
    }
}
