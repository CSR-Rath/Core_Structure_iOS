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
    
    private var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        messagingFirebase(application) // messaging firebase
        
        print("==> apiKey: \(AppConfiguration.shared.apiKey)") //AIzaSyBqVewVBMEhIqsP8uNDkkSD1wZYJCCXFgw
        GMSServices.provideAPIKey(AppConfiguration.shared.apiKey) // google maps
        
//        let refreshToken = "bf2d64d0-97d5-4b74-9ff4-9137b5c851a4"
//        let token = "eyJhbGciOiJIUzUxMiJ9.eyJyb2wiOlsiVVNSIl0sInN1YiI6IlpRdm1xM3g3TDJiSENxeXQwdGNvSUZlMEd3Mk02L05SNElXQ1gza0tIMWpEM0hYVW1xT2NSNW5zbUZ2YXB0NXUiLCJpYXQiOjE3NTI5MzkwMzUsImV4cCI6MTc1Mjk0MjYzNX0.F9jWGMLdAXKU6SMiV84NU-uDsewajevvHUpKgwGxbXSL2C0QBKpCtB86xkVNVSXqDsSTfCWoaO9btEorvAcW-g"

        
//        UserDefaults.standard.setValue(refreshToken, forKey: AppConstants.refreshToken)
//        UserDefaults.standard.setValue(token, forKey: AppConstants.token)
        
     
//        handleNearbyLocation()
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
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
}




// MARK: - Live location
extension AppDelegate{
    
    private func handleNearbyLocation(){
        
        LocationManager.shared.getCurrentLocation(isLiveLocation: true) { [self] currentLocation in
            
            guard let location = currentLocation else { return }
            
            // Fixed coordinate (Phnom Penh)
            let toLocation = CLLocation(latitude: 11.5564, longitude: 104.9282)
            
            let km =  LocationManager.shared.distance(from: location, to: toLocation, unit: .meters)
            
            if km < 500{
                LocationManager.shared.stopUpdatingLocation()
                pushNotificationNearby()
            }
        }
    }
    
    func pushNotificationNearby(title: String = "Message", body: String = "Nearby location"){
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



// MARK: - App Orientation
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
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask,
                                    andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
        
        // AppLockOrientationManager.lockOrientation(.portrait)
        // AppLockOrientationManager.lockOrientation(.landscape, andRotateTo: .landscapeRight)
    }
}



// MARK: - App lifecycle methods
extension AppDelegate{
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App did become active")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("App will resign active")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App entered background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("App will enter foreground")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will terminate") // kill app
    }
    
}

