//
//  GlobalFunction.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 25/2/25.
//

import UIKit

func rootViewController(newController: UIViewController) {
    // Wrap the new view controller in a UINavigationController
    let newNavController = UINavigationController(rootViewController: newController)
    newNavController.interactivePopGestureRecognizer?.isEnabled = false
    
    // Get the SceneDelegate
    guard let window = sceneDelegate else {
        print("Window nil")
        return
    }
    
    // Perform the transition with an animation
    UIView.transition(with: window,
                      duration: 0.2,
                      options: .transitionCrossDissolve,
                      animations: {
        window.rootViewController = newNavController
    })
}
