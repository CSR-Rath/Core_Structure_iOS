//
//  NotificationManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 17/6/25.
//

import Foundation
import UIKit

enum NotificationTypeEnum: String {
    
    // General
    case topUp = "TOP_UP"
    case transfer = "TRANSFER"
    case payment = "PAYMENT"
    case received = "RECEIVED"
    case revers = "REVERS"
    case recordSale = "RECORD_SALE"
    case correctBalance = "CORRECT_BALANCE"
    case correctProduct = "CORRECT_PRODUCT"
    case claim = "CLAIM"
    case purchaseRequest = "PURCHASE_REQUEST"
    case priceUpdate = "PRICE_UPDATE"
    case transferQR = "TRANSFER_QR"
    case receivedQR = "RECEIVED_QR"
    case returnQR = "RETURN_QR"
    case createAccount = "CREATE_ACCOUNT"
    
    // CounterType
    case receivedPayment = "RECEIVED_PAYMENT"
    case clearance = "CLEARANCE"
}

final class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    func rootNotificationViewController(userInfo: [AnyHashable : Any]) {
        let typeString = userInfo["type"] as? String ?? ""
        let notificationType = NotificationTypeEnum(rawValue: typeString)
        
        
        let typeRaw = userInfo["type"] as? String ?? ""
        let body = userInfo["body"] as? String ?? ""
        let refId = userInfo["refId"] as? String ?? ""
        
        
        let vc = FromeAlertVC()
        vc.view.backgroundColor = .orange
        
        // MARK: BVM
        
        
        //MARK: For present
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        getCurrentViewController()?.present(nav, animated: true)
        
    }
    
}

func getCurrentViewController()->UIViewController?{
    var currentViewController: UIViewController
    guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
        return nil
    }
    currentViewController = rootViewController
    
    while let presentedViewController = currentViewController.presentedViewController {
        currentViewController = presentedViewController
    }
    
    return currentViewController
}



class FromeAlertVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Alert Notification"
        leftBarButtonItem(isSwiping: false)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.dismissVC(){
            NotificationCenter.default.post(name: .popToRootVC, object: nil)
        }
        
    }
}


