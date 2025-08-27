//
//  LocalNotificationVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/11/24.
//

import UIKit

class LocalNotificationVC: BaseUIViewConroller {
    let buttonPush = BaseUIButton()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("Clear badge notification icon")
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0 // clear badge notification icon
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Push Notification"
        setupUIView()
        setupContainer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    private func setupUIView(){
        buttonPush.layer.cornerRadius = 10
        buttonPush.backgroundColor = .orange
        buttonPush.setTitle("Testing Push", for: .normal)
        buttonPush.onTouchUpInside = { [weak self] in
            self?.scheduleLocalNotification(body: "Testing")
        }
    }
    
    private func setupContainer(){
        buttonPush.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonPush)
        NSLayoutConstraint.activate([
            buttonPush.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonPush.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            buttonPush.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            buttonPush.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    
    
    func scheduleLocalNotification(body: String = "") {
        let content = UNMutableNotificationContent()
        content.title = "ទទួលប្រាក់ពី XXX XXX"
        content.body = body.isEmpty ? "500.00$ ទទួលបានក្នុងគណនី XXX XXX XXX" : body // Use the passed body or a default message (body default: testing)
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


