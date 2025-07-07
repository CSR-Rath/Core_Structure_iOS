//
//  AppDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import FirebaseCrashlytics
import LocalAuthentication



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        messagingFirebase(application) // messaging firebase
        
        GMSServices.provideAPIKey(AppConfiguration.shared.apiKey) // google maps
        
     
        LocationManager.shared.getCurrentLocation(isLiveLocation: true) { location in
            
            guard let location = location else { return }
            
            let latitude: Double =  11.5564
            let longitude: Double = 104.9282
            
            // Fixed coordinate (Phnom Penh)
            let toLocation = CLLocation(latitude: latitude, longitude: longitude)

            
            let km =  LocationManager.shared.distancew(formate: .mm,
                                                       fromLocation: location,
                                                       toLocation: toLocation)
            
            if km < 5000{
                LocationManager.shared.stopUpdatingLocation()
                self.nearbyLocation()
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func nearbyLocation(title: String = "title", body: String = "body"){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // 60 seconds for testing
        
        let request = UNNotificationRequest(identifier: "scheduledNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {


    private func messagingFirebase(_ application: UIApplication) {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
//                self.sendTestLocalNotification()
            }
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✅ FCM token: \(fcmToken ?? "")")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
              completionHandler([.banner, .sound, .badge]) // iOS 14+: Use .banner
          } else {
              completionHandler([.alert, .sound, .badge]) // iOS 10–13: Use .alert
          }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
    }
    
    func sendTestLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a local notification"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: true)
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


extension AppDelegate{
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return orientationLock
    }
    
    struct AppLockOrientationManager {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        // Forces the device to rotate to the specified orientation
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    // Lock to portrait only
//    AppLockOrientationManager.lockOrientation(.portrait)

    // Lock to landscape and rotate to landscape right
//    AppLockOrientationManager.lockOrientation(.landscape, andRotateTo: .landscapeRight)

}



