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


// MARK: - Enum Type
enum LanguageTypeEnum: String {
    case khmer = "km"
    case english = "en"
    case chinese = "zh"
}

enum FontNameEnum {

    enum EnglishEnum {
        static let light = "Roboto-Light"
        static let regular = "Roboto-Regular"
        static let medium = "Roboto-Medium"
        static let semibold = "Roboto-SemiBold"
        static let bold = "Roboto-Bold"
        static let italic = "Roboto-Italic"
    }

    enum KhmerEnum {
        static let light = "NotoSansKhmer-Light"
        static let regular = "NotoSansKhmer-Regular"
        static let medium = "NotoSansKhmer-Medium"
        static let semibold = "NotoSansKhmer-SemiBold"
        static let bold = "NotoSansKhmer-Bold"
    }

    enum ChineseEnum {
        static let light = "PingFangSC-Light"
        static let regular = "PingFangSC-Regular"
        static let medium = "PingFangSC-Medium"
        static let semibold = "PingFangSC-Semibold"
        static let bold = "PingFangSC-Bold"
    }
}


class LanguageManager {
    
    static let shared = LanguageManager()
    
    private let keyLanguage = "LANGUAGE"
    
    private init() {} // Prevent external initialization
    
    // Save selected language
    func setLanguage(_ lang: LanguageTypeEnum) {
        UserDefaults.standard.setValue(lang.rawValue, forKey: keyLanguage)
    }
    
    // Get language raw value (e.g. "en")
    func getLanguageCode() -> String {
        return UserDefaults.standard.string(forKey: keyLanguage) ?? LanguageTypeEnum.english.rawValue
    }
    
    // Get current language as enum type
    func getCurrentLanguage() -> LanguageTypeEnum {
        let rawValue = UserDefaults.standard.string(forKey: keyLanguage) ?? LanguageTypeEnum.english.rawValue
        return LanguageTypeEnum(rawValue: rawValue) ?? .english
    }
    
    // Optional: async style completion (but generally unnecessary here)
    func getCurrentLanguage(completion: @escaping (LanguageTypeEnum) -> Void) {
        let lang = getCurrentLanguage()
        completion(lang)
    }
}



class AppManager{
    
    static let shared = AppManager()

    
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
