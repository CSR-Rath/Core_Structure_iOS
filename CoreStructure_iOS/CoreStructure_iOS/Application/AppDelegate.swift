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
        
        setLanguage(langCode: .english) // default language en
        handleConfigurationRealmSwift() // Realm Swift
        handleNavicationTitle() // Title navigation bar
        configureNotification() // Push notification 2 local
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

//MARK: =================================== End AppDelegate ====================================





// MARK: =============================== Start Handle Deep Link =================================
extension AppDelegate{
    
    // Step create deep link
    /// 1 - click project --> target --> info -->  URL Type  -->  URL  scheme  --> set url for open it (Example: testingApp) (when open use  ====> testingApp://)
    /// 2 - next add func below
    ///
    
    // it still working when comment all this code
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard let url = userActivity.webpageURL else { //    myapp://path/to/content?id=123
            return false
        }
        
        // Handle the URL similar to the URL scheme
        let path = url.path
        if path == "/path/to/content" {
            if let id = url.queryParameters?["id"] {
                navigateToContent(withId: id)
            }
        }
        
        return true
    }
    
    private func navigateToContent(withId id: String) {
        
        print("navigateToContent(withId id: String)")
        
    }
    
    // MARK: - Handle when call from another App use Deep Link (Open this app)
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        if let url =  URL(string: "myapp://") {
    //
    //            DispatchQueue.main.async {
    //                UIApplication.shared.open(url, options: [:]) { success in
    //                    print("Deep Link \(success)")
    //                    if !success {
    //                        UIApplication.shared.open(url, options: [:]) { success in
    //                            print("Deep Link to AppStore \(success)")
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
}

// Extension to parse query parameters
extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { dict, item in
            dict[item.name] = item.value
        }
    }
}

// MARK: =============================== End Handle Deep Link ===================================


// MARK: =============================== Start Handle navigation contoller =======================

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

// MARK: =============================== End Handle navigation contoller =========================



// MARK: =============================== Start Setup Push Notification ============================
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Request notification
    private func configureNotification(){
        // Request user authorization for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            granted ? print("User granted authorization") :  print("User denied authorization")
        }
        // Set the delegate for UNUserNotificationCenter
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    // Will loading notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Loading.shared.hideLoading()
        
        updateBadgeIncrease() // call increase badge notivication
        
        // Handle the notification
        let userInfo = notification.request.content.userInfo;  print("userInfo ==> \(userInfo)")
        
        completionHandler([.list, .banner, .sound])

    }
    
    // didSelected notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
      
        // Handle the notification response here
        let userInfo = response.notification.request.content.userInfo; print("userInfo: \(userInfo)")
        
       
        
        guard let window = SceneDelegate.shared.sceneDelegate?.window,
              let navigationController = window.rootViewController as? UINavigationController  else{
            
            print("Error: Unable to access window or root view controller.")
            
            completionHandler()
            return
        }
        
        let targetViewController = UIViewController()
        targetViewController.view.backgroundColor = .red
        navigationController.pushViewController(targetViewController, animated: false)
        
        completionHandler() // Call the completion handler when you're done processing the notification
        
    }
    
    
    func updateBadgeIncrease() { // handle badge notificaation on the app icon
        
        DispatchQueue.main.async {  // Badge sayısını güncelle
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
    
}

// MARK: =============================== End Setup Push Notification ==============================


// MARK: =============================== Start Hanlde Realm Swift =================================

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

// MARK: =============================== End Hanlde Realm Swift ===================================
