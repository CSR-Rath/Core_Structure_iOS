//
//  AlertMessage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/9/24.
//

import UIKit


enum HandleMessageResponse{
    case code200
    case code400
    case code401
    case code404
    case code500
    case internet
    case none
    case timedOut
    case cannotConnectToHost
    case notConnectedToInternet
    case badURL
    case requestError
    
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
        case .internet:
            return "Internet is't connected. Please check your internet."
        case .timedOut:
            return "The request timed out. Please try again."
        case .cannotConnectToHost:
            return "Cannot connect to the host. Please check your internet connection."
        case .badURL:
            return "The URL is invalid."
        case .requestError:
            return "Request Error" // need missage from server
        case .notConnectedToInternet:
            return "Not connected to the Internet. Please check your network settings."
       
        }
    }
}

struct Response:Codable {
    var status: Int?
    var message: String?
}


class AlertMessage{
    
    static let shared = AlertMessage()
    
    func isSuccessfulResponse(_ response: Response, success: @escaping () -> Void){
        DispatchQueue.main.async {
            if response.status == 200{
                success()
            }else{
                self.alertError(message: response.message ?? nil)
            }
        }
    }
    
    func alertError(title: String = "Error",
                   message: String? = "", // "Something Went Wrong!",
                   status: HandleMessageResponse = .none
    ) {
        
        DispatchQueue.main.async {
            
            let bottomSheetVC = AlertErrorVC()

            bottomSheetVC.modalPresentationStyle = .custom
            bottomSheetVC.transitioningDelegate = presentVC

            
            bottomSheetVC.lblTitle.text = title
            
            if message == nil || message == "" {
                bottomSheetVC.lblDescription.text = status.message
            }else{
               bottomSheetVC.lblDescription.text =  message
            }
            
            print("message ==> ", status.message)
            
       
            SceneDelegate().window?.rootViewController?.present(bottomSheetVC,
                                                                animated: false,
                                                                completion: {
                Loading.shared.hideLoading()
                return // Stop resuming
            })
            
//            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//                sceneDelegate.window?.rootViewController?.present(bottomSheetVC,
//                                                                  animated: false,
//                                                                  completion: {

//                })
//            }
        }
    }
}


