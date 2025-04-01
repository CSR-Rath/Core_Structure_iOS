//
//  LoadType.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 23/8/24.
//

import Foundation

private let keyLanguage: String = "LANGUAGE_TYPE"

extension String {
    func localizeString() -> String {
        let lang = UserDefaults.standard.string(forKey: keyLanguage)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

enum LanguageTypeEnum: String {
    case KHMER = "km" // Khmer language
    case ENGLISH = "en" // English language
    case NONE = "_"
}

enum AccountTypeEnum: String {
    case GENERAL_ACCOUNT = "GENERAL_ACCOUNT"
    case COUNTER_ACCOUNT = "COUNTER_ACCOUNT"
    case STATION_ACCOUNT = "STATION_ACCOUNT"
    case NONE = "_"
}

enum NotificationTypeEnum: String{
    case NEW_STATION = "NEW_STATION"
    case NEAR_STATION = "NEAR_STATION"
    case NONE = "_"
}

enum TansactionTypeEnum: String{
    case PAYMENY = "PAYMENY"
    case TANSFER_QR = "TANSFER_QR"
    case TANSFER_FAVORIT = "TANSFER_FAVORIT"
    case NONE = "_"
}


class AppManager{

    private let keyAccount: String = "ACCOUNT_TYPE"
    private let keyNotification: String = "NOTIFICATION_TYPE"
    private let keyTransaction: String = "TANSACTION"
    
    static let shared = AppManager()
    
    func setLanguageTypes(langCode: LanguageTypeEnum) {
        UserDefaults.standard.setValue(langCode.rawValue, forKey: keyLanguage)
    }
    
    func getLanguageTypes(completion: @escaping (_ languageType: LanguageTypeEnum) -> Void) {
        let type = UserDefaults.standard.string(forKey: keyLanguage) ?? ""
        let currentType: LanguageTypeEnum = LanguageTypeEnum(rawValue: type) ?? .NONE
        completion(currentType)
    }
    
    func getAccountTypes(completion: @escaping (_ accountType: AccountTypeEnum) -> Void) {
        let type = UserDefaults.standard.string(forKey: keyAccount) ?? ""
        let currentType: AccountTypeEnum = AccountTypeEnum(rawValue: type) ?? .NONE
        completion(currentType)
    }
    
    func getNotificationTypes(completion: @escaping (_ notificationType: NotificationTypeEnum) -> Void) {
        let type = UserDefaults.standard.string(forKey: keyNotification) ?? ""
        let currentType: NotificationTypeEnum = NotificationTypeEnum(rawValue: type) ?? .NONE
        completion(currentType)
    }
    
    func getTansactionTypes(completion: @escaping (_ transactionType: TansactionTypeEnum) -> Void) {
        let type = UserDefaults.standard.string(forKey: keyTransaction) ?? ""
        let currentType: TansactionTypeEnum = TansactionTypeEnum(rawValue: type) ?? .NONE
        completion(currentType)
    }
    
}


class Using{
    
    
    init(){
        
        AppManager.shared.getLanguageTypes { languageType in
            
            switch languageType{
            case .ENGLISH:
                break
            case .KHMER:
                break
            case .NONE:
                break
            }
        }
        
        AppManager.shared.getAccountTypes { accountType in
            switch accountType{
            case .COUNTER_ACCOUNT:
                
                break
            case .GENERAL_ACCOUNT:
                
                break
            case .STATION_ACCOUNT:
                
                break
            case .NONE:
                break
            }
        }
        
        AppManager.shared.getTansactionTypes { transactionType in
            switch transactionType{
            case .PAYMENY:
                
                break
            case .TANSFER_QR:
                
                break
            case .TANSFER_FAVORIT:
                
                break
            case .NONE:
                
                break
            }
        }
        
        AppManager.shared.getNotificationTypes  { notificationType in
            
            print("transctionType ===> \(notificationType)")
            
            switch notificationType{
            case .NEAR_STATION:
                
                break
            case .NEW_STATION:
                
                break
            case .NONE:
                
                break
            }
        }
    }
}
