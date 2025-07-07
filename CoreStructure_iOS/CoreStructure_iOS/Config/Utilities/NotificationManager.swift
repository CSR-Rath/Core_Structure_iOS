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

class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    func rootNotificationViewController(userInfo: [AnyHashable : Any]) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let rootPresent = sceneDelegate.window?.rootViewController,
              let rootPush = sceneDelegate.window?.rootViewController as? UINavigationController
        else { print("===> WindowScene is Nil"); return }
        
        
        // Example: parse notification type from userInfo
        let type = userInfo["type"] as? String ?? ""
        let body = userInfo["body"] as? String ?? ""
        let refId = userInfo["refId"] as? String ?? ""
        
        
        let vc = UIViewController()
        vc.view.backgroundColor = .orange
        
        let notificationType =  NotificationTypeEnum(rawValue: type)
        
        switch notificationType{
            
            // MARK: - General Account
        case .topUp:
            rootPresent.present(vc, animated: true)
        case .transfer:
            rootPresent.present(vc, animated: true)
        case .payment:
            rootPresent.present(vc, animated: true)
        case .received:
            rootPresent.present(vc, animated: true)
        case .revers:
            rootPresent.present(vc, animated: true)
        case .recordSale:
            rootPresent.present(vc, animated: true)
        case .correctBalance:
            rootPresent.present(vc, animated: true)
        case .correctProduct:
            rootPresent.present(vc, animated: true)
        case .claim:
            rootPresent.present(vc, animated: true)
        case .purchaseRequest:
            rootPresent.present(vc, animated: true)
        case .priceUpdate:
            rootPresent.present(vc, animated: true)
        case .transferQR:
            rootPresent.present(vc, animated: true)
        case .receivedQR:
            rootPresent.present(vc, animated: true)
        case .returnQR:
            rootPresent.present(vc, animated: true)
        case .createAccount:
            rootPresent.present(vc, animated: true)
            
            // MARK: - Counter Account
        case .receivedPayment:
            rootPresent.present(vc, animated: true)
        case .clearance:
            rootPresent.present(vc, animated: true)
        case .none:
            rootPush.pushViewController(vc, animated: true)
            print("===> Empty case")
        }
    }
    
}

