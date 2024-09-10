//
//  AlertMessage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/9/24.
//

import UIKit


enum ConnectionError{
    case error400
    case error401
    case error404
    case error500
    case none
}


class AlertMessage{
    
    static let shared = AlertMessage()
    
    func showAlert(title: String = "Message!",
                   message: String?,
                   error: ConnectionError = .none
    ) {
        
        DispatchQueue.main.async {
           
            let bottomSheetVC = AlertMessageVC()
            bottomSheetVC.modalTransitionStyle = .crossDissolve
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            bottomSheetVC.lblTitle.text = title
            
            if  message == nil || message == "" {
                bottomSheetVC.lblDescription.text =  "Something Went Wrong"
            }else{
                bottomSheetVC.lblDescription.text =  message
            }
            
            //MARK: Handle image error
            switch error{
            case .error400:
                break
            case .error401:
                break
            case .error404:
                break
            case .error500:
                break
            case .none:
                break
            }
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController?.present(bottomSheetVC,
                                                                  animated: true,
                                                                  completion: {
                    Loading.shared.hideLoading()
                })
            }
        }
    }
}






