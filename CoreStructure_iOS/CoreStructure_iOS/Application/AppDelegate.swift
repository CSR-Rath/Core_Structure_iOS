//
//  AppDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import UserNotifications //import UserNotifications 1 local
import RealmSwift
import LocalAuthentication

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setLanguage(langCode: .english) // default language en
        handleConfigurationRealmSwift() // Realm Swift
        handleNavicationTitle() // Title navigation bar
        configureNotification() // Push notification 2 local
        print ( " getBiometricsName()" , getBiometricsName()) // Get Biometrice name
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


extension AppDelegate{
    
   private func getBiometricsType() -> LABiometryType {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return .none }
        return context.biometryType
    }

    private func getBiometricsName() -> String {
        switch getBiometricsType() {
        case .faceID:
            print("FaceID"); return "FaceID"
        case .touchID:
            print("TouchID"); return "TouchID"
        case .none:
            print("Biometrics Unavailable"); return "Biometrics Unavailable"
        case .opticID:
            print("Biometrics opticID"); return "Biometrics opticID"
        @unknown default:
            print("Biometrics Unavailable"); return "Biometrics Unavailable"
        }
    }
}









// MARK: =============================== Start Handle Deep Link =================================
extension AppDelegate{
    
    // Step create deep link
    /// 1 - click project --> target --> info -->  URL Type  -->  URL  scheme  --> set url for open it (Example: testingApp) (when open use  ====> testingApp://)
    /// 2 - next add func below
    ///
    
    // it still working when comment all this code
    
    
    
    //MARK: -  Handle Deplink
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("UIApplication.OpenURLOptionsKey")
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let scheme = urlComponents?.scheme{
           
            if (urlComponents?.host) != nil {
                print("scheme \(scheme)")

            }
        }
        return true
    }
    
    
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
    
    
   private func updateBadgeIncrease() { // handle badge notificaation on the app icon
        
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
    

    var config = Realm.Configuration(

        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).

        schemaVersion: 0,

        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above

        migrationBlock: { migration, oldSchemaVersion in

            // We haven’t migrated anything yet, so oldSchemaVersion == 0

            if (oldSchemaVersion < 3) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
    })

    Realm.Configuration.defaultConfiguration = config
    config = Realm.Configuration()
//    config.deleteRealmIfMigrationNeeded = true
    
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let realmURL = documentsDirectory.appendingPathComponent("default.realm")
    
        if fileManager.fileExists(atPath: realmURL.path) {
            print("Realm file exists at: \(realmURL.path)")
        } else {
            print("Realm file does not exist.")
        }
}

// MARK: =============================== End Hanlde Realm Swift ===================================


