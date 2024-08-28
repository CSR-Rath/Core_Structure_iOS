//
//  AlertMessage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/8/24.
//

import Foundation
import UIKit

extension UIViewController{

    func alerMessage(message: String = "This is an alert message.",
                   completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Message!",
                                      message: message,
                                      preferredStyle: .alert)

        // Yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion(true)
        }
        
        // No action
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            self.dismiss(animated: true) {
                completion(false)
            }
        }

        alert.addAction(yesAction)
        alert.addAction(noAction)

        // Access the window from SceneDelegate
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            if let window = sceneDelegate.window {
                // Present the alert from the root view controller
                if let rootViewController = window.rootViewController {
                    rootViewController.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
