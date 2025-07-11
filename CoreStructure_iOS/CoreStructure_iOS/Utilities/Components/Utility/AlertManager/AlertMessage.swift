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
    var status: Int
    var message: String
    var list: [String]
}




class AlertMessage{
    
    static let shared = AlertMessage()
    private var alertVC: AlertErrorVC?
    
    func isSuccessfulResponse(_ response: Response, success: @escaping () -> Void){
        DispatchQueue.main.async {
            if response.status == 200{
                success()
            }else{
                self.alertError(message: response.message)
            }
        }
    }
    
    func alertError(title: String = "Error",
                    message: String = "Something Went Wrong!",
                    status: HandleMessageResponse = .none
    ) {
        
        DispatchQueue.main.async { [self] in
            
            guard self.alertVC == nil else { return }
            
            let bottomSheetVC = AlertErrorVC()
            
            bottomSheetVC.modalPresentationStyle = .custom
            bottomSheetVC.transitioningDelegate = presentVC
            
            bottomSheetVC.lblTitle.text = "Error"
            bottomSheetVC.lblDescription.text = message // "Something Went Wrong!"
            
            print("message ==> ", status.message)
            
            // Store reference for later dismissalf
            self.alertVC = bottomSheetVC
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootPresent = windowScene.windows.first?.rootViewController,
                  let rootPush = windowScene.windows.first?.rootViewController as? UINavigationController
            else { return }
            
            rootPresent.present(bottomSheetVC, animated: true, completion: {
                Loading.shared.hideLoading()
            })
        }
    }
    
    // Update the alert message to "connected" and dismiss after delay
    func updateToConnectedMessageAndDismiss(after seconds: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            guard let vc = self.alertVC else { return }
            
            vc.lblTitle.text = "Internet"
            vc.lblDescription.text = "✅ Internet is now connected!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                vc.dismiss(animated: true) {
                    self.alertVC = nil
                }
            }
        }
    }
}
