//
//  AppDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import UserNotifications //import UserNotifications 1 local, (Notivication)
import LocalAuthentication // For Get Biometrics Name


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        printFontsName()
        LanguageManager.shared.setLanguage(langCode: .english) // set language
        configureNotification(application: application) // configure នotification
        print("didFinishLaunchingWithOptions")
        
        if #available(iOS 13.0, *) {
            print("ScenDelegate app lifecycle ")
        }else{
            print("AppDelegate app lifecycle")
        }

        NavigationBarAppearance.shared.navigationBarAppearance(titleColor: .black,
                                                               barAppearanceColor: .orange,
                                                               shadowColor: .clear)
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("configurationForConnecting")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("didDiscardSceneSessions") // working when kill app or close app
    }
    
}

// MARK: - Push Notification Setup
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    private func configureNotification(application: UIApplication) {
//        FirebaseApp.configure() // need cell for using  firebase

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            granted ? print("User granted authorization") : print("User denied authorization")
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    // when alert notivigation
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Loading.shared.hideLoading()
        updateBadgeIncreaseIconApp()
        
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
        
        guard let navigationController = windowSceneDelegate.rootViewController as? UINavigationController else {
            print("Push ==> NavigationController is nil.")
            completionHandler()
            return
        }
        
        guard let window = windowSceneDelegate else{
            print("Present ==> Window is nil")
            completionHandler()
            return
        }
        
        let targetViewController = UIViewController()
        targetViewController.leftBarButtonItem()
        targetViewController.view.backgroundColor = .orange
        
        
        if UIApplication.shared.applicationIconBadgeNumber % 2 == 0 {
            
            print("Controller is Present.")
            window.rootViewController?.present(targetViewController, animated: true)
            
        }
        else{
            
            print("Controller is Push.")
            navigationController.pushViewController(targetViewController, animated: true)
            
        }
        
//        let notificationType  = NotificationTypeEnum(rawValue: "")!; print("notificationType ==> \(notificationType)")
//        
//        switch notificationType{
//        case .NEAR_STATION:
//                break
//        case .NEW_STATION:
//            break
//        case .NONE:
//            break
//        }
                
        completionHandler()
    }
    
    private func updateBadgeIncreaseIconApp() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
    
}

// MARK: - Video from youtube(How to push notificatin cloud Messaging) https://www.youtube.com/watch?v=WmKRWoqdC_Y
// Apple Developer ==> certificated ==> identifi ==> Key ==> create key set key name ==> end nable tick push notification service ==> click continue ==> click rigister ==> clicl download ==> and then ==> firebase cloud  messaging ==> scroll ==> click upload APNs Key (get from Apple developer at pleace download key by cody keyID and teamId)  and then upload APNs auth key did download from Apple developer

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

func printFontsName(){

    for family in UIFont.familyNames {
        print("Font Family: \(family)")
        for fontName in UIFont.fontNames(forFamilyName: family) {
            print("    \(fontName)")
        }
    }
}
