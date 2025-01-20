//
//  SceneDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static let shared = SceneDelegate()
    
    internal var window: UIWindow?
    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
         window = UIWindow(windowScene: windowScene)
        
        let controller: UIViewController =  MultiSelectTableViewController() //DragDropViewController() //DisplayWebController()//SplashScreenVC()
        controller.view.backgroundColor = .gray
        let navigation = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}



//MARK: - Handle change root controller
extension SceneDelegate {
    
    private func changeRootViewController(_ vc: UIViewController, animated: Bool = false) {
        guard let window = self.window else { return }
        
        let navigation = UINavigationController(rootViewController: vc) // Create a navigation controller with the new root view controller
        
        window.rootViewController = navigation  // Set the root view controller without animation
        
        window.makeKeyAndVisible() // Make the window key and visible
    }
    
    func gotoTabBar(indexSelected: Int = 0){
        
        let tabBarController = CustomTabBarVC() // Replace with your custom tab bar controller
        tabBarController.indexSelected = indexSelected
        
        // Get the current scene delegate
        if let sceneDelegate = sceneDelegate {
            sceneDelegate.changeRootViewController(tabBarController)
        }else{
            print("error changeRootViewController")
        }
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


extension UIWindow{
    
    func changeRootViewController(_ vc: UIViewController) {
    let navigation = UINavigationController(rootViewController: vc)
    self.rootViewController = navigation  // Set the root view controller without animation
    self.makeKeyAndVisible() // Make the window key and visible
}
    
    private func saveSectionLogin(){
        //MARK: Check day for refresh token
//        let loginDate = Date()
//        let sevenDaysAfter = Calendar.current.date(byAdding: .day , value: 23, to: loginDate)!
//        let sevenMothAfter = Calendar.current.date(byAdding: .month , value: 1, to: loginDate)!
        
//        if  UserDefaults.standard.object(forKey: AppConstants.logInFirst) == nil {
//            UserDefaults.standard.set(sevenDaysAfter, forKey: AppConstants.changeDateDay)
//            UserDefaults.standard.set(sevenMothAfter, forKey: AppConstants.changeDateMonth)
//            UserDefaults.standard.set(true, forKey: AppConstants.logInFirst)
//        }
    }
    
}
