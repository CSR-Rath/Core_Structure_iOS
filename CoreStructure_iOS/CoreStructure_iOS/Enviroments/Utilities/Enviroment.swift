//
//  Enviroment.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 2/4/25.
//

import Foundation

// MARK: - Variable Name Key Type
private let keyAccountType: String = "ACCOUNT_TYPE"
private let keyNotificationType: String = "NOTIFICATION_TYPE"
private let keyTransactionType: String = "TANSACTION"
private let keyLanguageType: String = "LANGUAGE_TYPE"
private let keyLanguage = "LANGUAGE"

// MARK: - Enum Type
enum LanguageTypeEnum: String {
    case khmer = "km"
    case english = "en"
}

enum AccountTypeEnum: String {
    case generalAccount = "GENERAL_ACCOUNT"
    case counterAccount = "COUNTER_ACCOUNT"
    case stationAccount = "STATION_ACCOUNT"
    case cooperateAccount = "COOPERATE_ACCOUNT"
}

enum NotificationTypeEnum: String {
    case newStation = "NEW_STATION"
    case nearStation = "NEAR_STATION"
}

enum TransactionTypeEnum: String {
    case payment = "PAYMENY"
    case transferQRCode = "TANSFER_QR"
    case transferFavorite = "TANSFER_FAVORIT"
}


// MARK: - Extension
extension String {

    func localizeString() -> String {
        let lang = UserDefaults.standard.string(forKey: keyLanguageType)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

// MARK: - Class
class FontNameManager{
    // MARK: - Font English
    static let Roboto_Regular =  "Roboto-Regular"
    static let Roboto_Medium = "Roboto-Medium"
    static let Roboto_Bold =  "Roboto-Bold"
    
    // MARK: - Font Khmer
    static let NotoSansKhmer_Regular = "NotoSansKhmer-Regular"
    static let NotoSansKhmer_Medium = "NotoSansKhmer-Medium"
    static let NotoSansKhmer_Bold =  "NotoSansKhmer-Bold"
}


enum FontName {
    enum English {
        static let regular = "Roboto-Regular"
        static let medium = "Roboto-Medium"
        static let bold = "Roboto-Bold"
    }

    enum Khmer {
        static let regular = "NotoSansKhmer-Regular"
        static let medium = "NotoSansKhmer-Medium"
        static let bold = "NotoSansKhmer-Bold"
    }
}


class LanguageManager{
    
    static let shared = LanguageManager()
    
    private init() {} // prevent external init
    
    func setLanguage(langCode: LanguageTypeEnum) {
        UserDefaults.standard.setValue(langCode.rawValue, forKey: keyLanguage)
    }
    
    func getLanguageType() -> String{
        return UserDefaults.standard.string(forKey: keyLanguage) ?? "en"
    }
    
    func getLanguageTypes(completion: @escaping (_ languageType: LanguageTypeEnum) -> Void) {
        let type = UserDefaults.standard.string(forKey: keyLanguageType) ?? "en"
        let currentType: LanguageTypeEnum = LanguageTypeEnum(rawValue: type) ?? .english
        completion(currentType)
    }
    
}


class AppManager{
    
    static let shared = AppManager()
    
    func setLanguageTypes(langCode: LanguageTypeEnum) {
        UserDefaults.standard.setValue(langCode.rawValue, forKey: keyLanguageType)
    }
    
    
    func getAccountTypes(completion: @escaping (_ accountType: AccountTypeEnum) -> Void) {
        let type = UserDefaults.standard.string(forKey: keyAccountType) ?? ""
        let currentType: AccountTypeEnum = AccountTypeEnum(rawValue: type) ?? .generalAccount
        completion(currentType)
    }
    
    func getNotificationTypes(completion: @escaping (_ notificationType: NotificationTypeEnum) -> Void) {
        let type = UserDefaults.standard.string(forKey: keyNotificationType) ?? ""
        let currentType: NotificationTypeEnum = NotificationTypeEnum(rawValue: type) ?? .nearStation
        completion(currentType)
    }
    
    func getTansactionTypes(completion: @escaping (_ transactionType: TransactionTypeEnum) -> Void) {
        let type = UserDefaults.standard.string(forKey: keyTransactionType) ?? ""
        let currentType: TransactionTypeEnum = TransactionTypeEnum(rawValue: type) ?? .payment
        completion(currentType)
    }
    
}




enum NotificationType {
    case general(GeneralType)
    case counter(CounterType)
    
    enum GeneralType: String {
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
    }

    enum CounterType: String {
        case receivedPayment = "RECEIVED_PAYMENT"
        case clearance = "CLEARANCE"
    }
}


func getNotificationTypeValue(_ type: NotificationType) -> String {
    switch type {
    case .general(let generalType):
        return generalType.rawValue
    case .counter(let counterType):
        return counterType.rawValue
    }
}

let raw = getNotificationTypeValue(.general(.claim)) // returns "CLAIM"
