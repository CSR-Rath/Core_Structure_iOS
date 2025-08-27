//
//  Notification + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 9/11/24.
//

import Foundation
import UIKit

extension Notification.Name {
    static let dragDropStateChanged = Notification.Name("dragDropStateChanged")
    static let didUpdateData = Notification.Name("didUpdateData")
    static let newMessageNotification = Notification.Name("dragDropStateChanged")
}


class NotificationVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNewMessage(_:)),
            name: .newMessageNotification,
            object: nil
        )
        
        let button = BaseUIButton(frame: CGRect(x: (screen.width-300)/2,
                                                y:(screen.height-50)/2,
                                                width: 300,
                                                height: 50))
        button.setTitle("POST", for: .normal)
        button.onTouchUpInside = {
            self.sendNotification()
        }
        
        view.addSubview(button)
    }
    
    @objc func handleNewMessage(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let message = userInfo["message"] as? String {
            print("📩 Received message: \(message)")

            let alert = UIAlertController(title: "New Message",
                                          message: message,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            present(alert, animated: true)
        }
    }

    @objc func sendNotification() {
        let message = "Hello, Mr. Rath!"
        NotificationCenter.default.post(
            name: .newMessageNotification,
            object: nil,
            userInfo: ["message": message]
        )
        print("✅ Notification Sent!")
    }
    
}

