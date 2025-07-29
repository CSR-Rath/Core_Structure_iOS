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

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        configureFirebaseMessaging(application)
        configureGoogleMaps()
        
       
        
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Handle discarded scenes if needed
    }
}

// MARK: - Firebase Messaging and Notification Handling

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

    private func configureFirebaseMessaging(_ application: UIApplication) {
        FirebaseApp.configure()
        
        // Setup notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification authorization
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                // Authorization granted; handle if needed
            }
        }
        
        application.registerForRemoteNotifications()
        
        // Set messaging delegate
        Messaging.messaging().delegate = self
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✅ FCM token: \(fcmToken ?? "")")
        // Send token to your server if needed
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        // Handle notification response if needed
    }
}

// MARK: - Google Maps Configuration

private extension AppDelegate {
    func configureGoogleMaps() {
        print("==> apiKey: \(AppConfiguration.shared.apiKey)")
        GMSServices.provideAPIKey(AppConfiguration.shared.apiKey)
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

