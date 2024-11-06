//
//  LocalNotificationVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/11/24.
//

import UIKit

class LocalNotificationVC: UIViewController {
    let buttonPush = UIButton()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           title = "Push Notification"
           view.backgroundColor = .white
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


//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        // Do any additional setup after loading the view.
//    }
//    
//
//
//}
