//
//  AlertMessage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/9/24.
//

import UIKit

struct Response:Codable {
    var status: Int
    var message: String
    var list: [String]
}

class AlertMessage{
    
    static let shared = AlertMessage()
    
    func alertError(
        title: String = "Error",
        message: String = "Something Went Wrong!",
        completion: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
        
           
            
            let bottomSheetVC = AlertErrorVC()
            bottomSheetVC.modalPresentationStyle = .custom
            bottomSheetVC.transitioningDelegate = presentVC
            
            bottomSheetVC.lblTitle.text = title
            bottomSheetVC.lblDescription.text = message
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootPresent = windowScene.windows.first?.rootViewController
            else { return }
            
            rootPresent.present(bottomSheetVC, animated: true) {
                completion?()
                Loading.shared.hideLoading()
            }
        }
    }
}
