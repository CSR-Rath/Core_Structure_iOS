//
//  GlobalFunction.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 25/2/25.
//

import UIKit

class GlobalFunction{
    
  static func rootViewController(newController: UIViewController) {
        // Wrap the new view controller in a UINavigationController
        let newNavController = UINavigationController(rootViewController: newController)
        newNavController.interactivePopGestureRecognizer?.isEnabled = false
        
      
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first else { return }
        
        // Perform the transition with an animation
        UIView.transition(with: window,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            window.rootViewController = newNavController
        })
    }
}


