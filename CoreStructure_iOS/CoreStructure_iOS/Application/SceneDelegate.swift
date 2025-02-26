//
//  SceneDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit

var sceneDelegate: UIWindow!
var barAppearanHeight: CGFloat!
var bottomSafeAreaInsetsHeight: CGFloat!

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.rootViewController()
    }
    
    private func rootViewController(){
     
        let controller: UIViewController = ButtonOntheKeyboradVC()
        let navigation = UINavigationController(rootViewController: controller)
        window!.rootViewController = navigation
        window!.makeKeyAndVisible()
        
        // MARK: - configuretion height
        sceneDelegate = window!
        bottomSafeAreaInsetsHeight = window?.safeAreaInsets.bottom
        barAppearanHeight = navigation.navigationBar.frame.height + (window?.safeAreaInsets.top ?? 0)
        
        print("SafeAreaInsets bottom ==> \(bottomSafeAreaInsetsHeight ?? 0)")
        print("AppearanHeight ==> \(barAppearanHeight ?? 0)")
    }
}

extension SceneDelegate{
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
    }
    
}



// SwiftUI is have func (onAppear and onDisappear) = (viewWillAppear or viewDidAppear) and (viewWillDisappear or viewDidDisappear or viewDidload)
