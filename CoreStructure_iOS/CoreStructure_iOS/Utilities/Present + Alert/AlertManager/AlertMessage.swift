//
//  AlertMessage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/9/24.
//

import UIKit


enum StatusCode{
    case code200
    case code400
    case code401
    case code404
    case code500
    case none
    
    var message: String {
        switch self {
        case .code200:
            return "Bad Request: The server could not understand the request."
        case .code400:
            return "Unauthorized: Authentication is required and has failed."
        case .code401:
            return "Unauthorized: Access is denied due to invalid credentials."
        case .code404:
            return "Not Found: The requested resource could not be found."
        case .code500:
            return "Internal Server Error: The server encountered an unexpected condition."
        case .none:
            return "Something went wrong."
        }
    }
}

struct Response:Codable {
    var status: Int?
    var message: String?
}


class AlertMessage{
    
    static let shared = AlertMessage()
    
    func showAlert(title: String = "Message!",
                   message: String? = "Something Went Wrong",
                   status: StatusCode = .none
    ) {
        
        DispatchQueue.main.async {
            
            let bottomSheetVC = AlertErrorVC()
            bottomSheetVC.modalTransitionStyle = .crossDissolve
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            bottomSheetVC.lblTitle.text = title
            
            if  message == nil || message == "" {
                bottomSheetVC.lblDescription.text =  status == .none ? message :  status.message
            }else{
                bottomSheetVC.lblDescription.text =  message
            }
            
            //MARK: Handle image error
            switch status{
            case .code200:
                break
            case .code400:
                break
            case .code401:
                break
            case .code404:
                break
            case .code500:
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
    
    func showAlertInternet(title: String = "Message!",
                   message: String? = "Internet isn't connected.",
                   status: StatusCode = .none
    ) {
        
        DispatchQueue.main.async {
            
            let vc = AlertInternetVC()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.lblTitle.text = title
            
            if  message == nil || message == "" {
                vc.lblDescription.text =  status == .none ? message :  status.message
            }else{
                vc.lblDescription.text =  message
            }
            
            //MARK: Handle image error
            switch status{
            case .code200:
                break
            case .code400:
                break
            case .code401:
                break
            case .code404:
                break
            case .code500:
                break
            case .none:
                break
            }
            
       
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController?.present(vc,
                                                                  animated: true,
                                                                  completion: {
                    Loading.shared.hideLoading()
                })
            }
        }
    }
    
    
    func isSuccessfulResponse(_ response: Response) -> Bool{
        
        if response.status == 200{
            return true
        }else{
            self.showAlert(message: response.message ?? nil)
            return false
        }
        
    }
}


