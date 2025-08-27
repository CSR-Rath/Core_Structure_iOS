//
//  PaymentViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 17/3/25.
//

import UIKit

class PaymentVC: BaseUIViewConroller {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Process Payment"
        
        let buttonPay = BaseUIButton(frame: CGRect(x: (Int(screen.width)-300)/2,
                                                   y: (Int(screen.height)-50)/2,
                                                   width: 300,
                                                   height: 50))
        buttonPay.setTitle("Pay Now", for: .normal)
        buttonPay.onTouchUpInside = {
            self.openYouTubeVideo(videoID: "")
        }
        
        view.addSubview(buttonPay)

    }
    
    func openYouTubeVideo(videoID: String) {
        
        if let url =  URL(string: "https://www.youtube.com/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                /// root url to open app store download it.
                if let webUrl = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
                    UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                }
            }
        }
        
        /// call observer when root url deep link successfully
        NotificationCenter.default.addObserver(self, selector: #selector(self.paymentStatus),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    @objc private func paymentStatus(){
        Loading.shared.showLoading()
        Loading.shared.hideLoading(seconds: 0.60) {
            /// remove notification UIApplication.didBecomeActiveNotification
            
            NotificationCenter.default.removeObserver(self,
                                                      name: UIApplication.didBecomeActiveNotification,
                                                      object: nil)
            
            AlertMessage.shared.alertError(title: "Message!", message: "Successfully")
        }
    }

}
