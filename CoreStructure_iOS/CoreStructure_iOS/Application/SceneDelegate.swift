//
//  SceneDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit


// MARK: - Global variable
var windowSceneDelegate: UIWindow!
var barAppearanHeight: CGFloat!
var bottomSafeAreaInsetsHeight: CGFloat!
let screen = UIScreen.main.bounds
let igorneSafeAeaTop: CGRect = CGRect(x: 0,
                                      y: Int(barAppearanHeight),
                                      width: Int(screen.width),
                                      height: Int(screen.height-barAppearanHeight))


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        networkMonitoring()
        rootViewController()
        
        let amount : Double = 10.67
        
        print("KHR ==\(amount.toCurrencyAsKHR)")
        print("USD ==\(amount.toCurrencyAsUSD)")
        
    }
    
    private func rootViewController(){
        
        let controller: UIViewController = DemoFeatureVC()
        let navigation = UINavigationController(rootViewController: controller)
        window!.rootViewController = navigation
        window!.makeKeyAndVisible()
        
        // MARK: - configuretion height
        windowSceneDelegate = window!
        bottomSafeAreaInsetsHeight = window?.safeAreaInsets.bottom
        barAppearanHeight = navigation.navigationBar.frame.height + (window?.safeAreaInsets.top ?? 0)
    }
    
    private func networkMonitoring(){
        NetworkMonitor.shared.onStatusChange = { isConnected in
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootVC = windowScene.windows.first?.rootViewController else { return }
            
            let alertNetwork = AlertNetwork()
            alertNetwork.transitioningDelegate = presentVC
            alertNetwork.modalPresentationStyle = .custom
            
            if isConnected {
                print("✅ Internet connected")
                
                if let presentedAlert = rootVC.presentedViewController {
                    presentedAlert.dismiss(animated: true)
                }
                
            } else {
                print("❌ Internet disconnected")
                
                if rootVC.presentedViewController == nil {
                    rootVC.present(alertNetwork, animated: true)
                }
            }
        }
    }
}


extension SceneDelegate {
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground") // App is coming to the foreground but not yet active. (From background)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive") // App is now active and interactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive") // App is about to move from active to inactive (e.g., user pressed Home button).
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground") // App is now in the background but not terminated.
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect") // Scene is removed (e.g., app is fully closed or scene is discarded).
    }
    
}
