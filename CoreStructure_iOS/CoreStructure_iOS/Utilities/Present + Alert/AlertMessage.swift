//
//  AlertMessage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/9/24.
//

import UIKit


enum ErrorStatus{
    case error400
    case error401
    case error404
    case error500
    case none
    
    var message: String {
        switch self {
        case .error400:
            return "Bad Request: The server could not understand the request."
        case .error401:
            return "Unauthorized: Authentication is required and has failed."
        case .error404:
            return "Not Found: The requested resource could not be found."
        case .error500:
            return "Internal Server Error: The server encountered an unexpected condition."
        case .none:
            return "Something Went Wrong"
        }
    }
}


class AlertMessage{
    
    static let shared = AlertMessage()
    
    func showAlert(title: String = "Message!",
                   message: String?,
                   error: ErrorStatus = .none
    ) {
        
        DispatchQueue.main.async {
           
            let bottomSheetVC = AlertMessageVC()
            bottomSheetVC.modalTransitionStyle = .crossDissolve
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            bottomSheetVC.lblTitle.text = title
            
            if  message == nil || message == "" {
                bottomSheetVC.lblDescription.text =  error == .none ? message :  error.message
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






