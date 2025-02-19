//
//  AppDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import UserNotifications //import UserNotifications 1 local
import RealmSwift //For DB locale data
import LocalAuthentication // For Get Biometrics Name

var config: Realm.Configuration!
var realm: Realm!

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setLanguage(langCode: .english) // english default
        handleConfigurationRealmSwift() // realmSwift
        configureNotification() // notivication
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("didDiscardSceneSessions")
    }
}

// MARK: - Biometrics Handling
extension AppDelegate {
    
    private func getBiometricsType() -> LABiometryType {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return .none }
        return context.biometryType
    }
    
    private func getBiometricsName() -> String {
        switch getBiometricsType() {
        case .faceID:
            return "FaceID"
        case .touchID:
            return "TouchID"
        case .none:
            return "Biometrics Unavailable"
        case .opticID:
            return "Biometrics opticID"
        @unknown default:
            return "Biometrics Unavailable"
        }
    }
}

// MARK: - Push Notification Setup
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    private func configureNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            granted ? print("User granted authorization") : print("User denied authorization")
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    // when alert notivigation
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Loading.shared.hideLoading()
        updateBadgeIncrease()
        
        let userInfo = notification.request.content.userInfo
        print("Notification User Info:", userInfo)
        
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .sound])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    // click on nitivigation
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("Notification Response User Info:", userInfo)
        
        guard let sceneDelegate = sceneDelegate,
              let navigationController = sceneDelegate.window?.rootViewController as? UINavigationController else {
            print("Error: Unable to access window or root view controller.")
            completionHandler()
            return
        }
        
        let targetViewController = UIViewController()
        targetViewController.view.backgroundColor = .red
        navigationController.pushViewController(targetViewController, animated: false)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received remote notification in foreground")
    }
    
    private func updateBadgeIncrease() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
}

//MARK: -  RealmSwift
extension AppDelegate{
  private func handleConfigurationRealmSwift() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let realmURL = documentsDirectory.appendingPathComponent("default.realm")
        
        if fileManager.fileExists(atPath: realmURL.path) {
            print("Realm file exists at:", realmURL.path)
        } else {
            print("Realm file does not exist.")
        }
        
        config = Realm.Configuration(schemaVersion: 0, migrationBlock: { _, _ in })
        Realm.Configuration.defaultConfiguration = config
    }
}
