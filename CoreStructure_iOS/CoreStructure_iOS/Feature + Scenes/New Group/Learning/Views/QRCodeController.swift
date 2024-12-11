//
//  QRCodeController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 29/11/24.
//

import UIKit

class QRCodeController: UIViewController {
    
    let qrCodeImageView = UIImageView()
    let constainerView = UIView()
    let dashLineView = DashedLineView()
    
    let lblAmount = UILabel()
    let lblDescription = UILabel()
    
    let topView = UIView()
    let triangleView = TriangleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment KHQR"
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { //// Delay for 1 minute ( seconds)
            self.scheduleLocalNotification()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leftBarButton()

    }
    
    
    func scheduleLocalNotification(body: String = "") {
        let content = UNMutableNotificationContent()
        content.title = "Payment Order Success!."
        content.body = " Your payment of \(lblAmount.text ?? "") has been successfully processed. Thank you for your order!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.3, repeats: false) // 1 = 60 seconds for testing
        
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

extension QRCodeController{
    
    func setupUI() {
        view.backgroundColor = .lightGray
        
        constainerView.layer.cornerRadius = 20
        constainerView.backgroundColor = .white
        constainerView.clipsToBounds = true
        constainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(constainerView)
        
        qrCodeImageView.image = .imgQRCode
        qrCodeImageView.layer.cornerRadius = 5
        qrCodeImageView.backgroundColor = .clear
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        constainerView.addSubview(qrCodeImageView)
        
        topView.backgroundColor = .red
        topView.translatesAutoresizingMaskIntoConstraints = false
        constainerView.addSubview(topView)
        
        dashLineView.backgroundColor = .clear
        dashLineView.translatesAutoresizingMaskIntoConstraints = false
        constainerView.addSubview(dashLineView)
        
        lblAmount.textColor = .mainBlueColor
        lblAmount.fontMedium(24)
        lblAmount.translatesAutoresizingMaskIntoConstraints = false
        constainerView.addSubview(lblAmount)
      
        lblDescription.text = "SETEC Institute (SS-15)"
        lblDescription.fontRegular(18)
        lblDescription.textColor = .mainBlueColor
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        constainerView.addSubview(lblDescription)
        
        triangleView.backgroundColor = .red
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        constainerView.addSubview(triangleView)
    
        NSLayoutConstraint.activate([
            
            constainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            constainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            constainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            constainerView.heightAnchor.constraint(equalToConstant: 410),
            
            qrCodeImageView.centerXAnchor.constraint(equalTo: constainerView.centerXAnchor),
            qrCodeImageView.bottomAnchor.constraint(equalTo: constainerView.bottomAnchor,constant: -35),
            qrCodeImageView.widthAnchor.constraint(equalToConstant: 200),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: 200),
            
            topView.topAnchor.constraint(equalTo: constainerView.topAnchor),
            topView.leftAnchor.constraint(equalTo: constainerView.leftAnchor),
            topView.rightAnchor.constraint(equalTo: constainerView.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            dashLineView.bottomAnchor.constraint(equalTo: qrCodeImageView.topAnchor,constant: -35),
            dashLineView.leftAnchor.constraint(equalTo: constainerView.leftAnchor),
            dashLineView.rightAnchor.constraint(equalTo: constainerView.rightAnchor),
            dashLineView.heightAnchor.constraint(equalToConstant: 1.5),
            
            
            lblDescription.leftAnchor.constraint(equalTo: qrCodeImageView.leftAnchor),
            lblDescription.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: 15),
          
            lblAmount.leftAnchor.constraint(equalTo: qrCodeImageView.leftAnchor),
            lblAmount.bottomAnchor.constraint(equalTo: dashLineView.topAnchor,constant: -15),
            
            triangleView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            triangleView.rightAnchor.constraint(equalTo: topView.rightAnchor),
            triangleView.widthAnchor.constraint(equalToConstant: 20),
            triangleView.heightAnchor.constraint(equalToConstant: 35)
             
        ])
    }
    
}







