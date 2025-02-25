//
//  AppDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import UserNotifications //import UserNotifications 1 local
import LocalAuthentication // For Get Biometrics Name
import Firebase

// Firebase Messaging need have account developer for

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setLanguage(langCode: .english) // english default
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
        FirebaseApp.configure() // need cell for using  firebase
        
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

    private func updateBadgeIncrease() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
}

// MARK: - Video from youtube(How to push notificatin cloud Messaging) https://www.youtube.com/watch?v=WmKRWoqdC_Y
// Apple Developer ==> certificated ==> identifi ==> Key ==> create key set key name ==> end nable tick push notification service ==> click continue ==> click rigister ==> clicl download ==> and then ==> firebase cloud  messaging ==> scroll ==> click upload APNs Key (get from Apple developer at pleace download key by cody keyID and teamId)  and then upload APNs auth key did download from Apple developer
