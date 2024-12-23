//
//  LocalNotificationVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/11/24.
//

import UIKit

class LocalNotificationVC: UIViewController, UIGestureRecognizerDelegate {
    let buttonPush = MainButton()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           title = "Push Notification"
           view.backgroundColor = .white
           //Enable back swipe gesture
           navigationController?.interactivePopGestureRecognizer?.delegate = self
           
           setupUIView()
           setupContainer()
       }
       
       
       private func setupUIView(){
           buttonPush.layer.cornerRadius = 10
           buttonPush.backgroundColor = .orange
           buttonPush.setTitle("Testing Push", for: .normal)
           buttonPush.addTarget(self, action: #selector(didTappedButtonPush), for: .touchUpInside)
       }
       
       private func setupContainer(){
           buttonPush.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(buttonPush)
           NSLayoutConstraint.activate([
               buttonPush.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               buttonPush.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
               buttonPush.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
               buttonPush.heightAnchor.constraint(equalToConstant: 50),
   //            buttonPush.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
           ])
       }
       
       @objc private func didTappedButtonPush(){
           print("didTappedButtonPush")
           self.scheduleLocalNotification(body: "Testing")
       }
       
       func scheduleLocalNotification(body: String = "") {
           let content = UNMutableNotificationContent()
           content.title = "ទទួលប្រាក់ពី XXX XXX"
           content.body = "500.00$ ទទួលបានក្នុងគណនី XXX XXX XXX"
           content.sound = UNNotificationSound.default
           
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // 60 seconds for testing
           
           let request = UNNotificationRequest(identifier: "scheduledNotification", content: content, trigger: trigger)
           
           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Error scheduling notification: \(error.localizedDescription)")
               } else {
                   print("Notification background scheduled successfully.")
               }
           }
           
       }
   }


