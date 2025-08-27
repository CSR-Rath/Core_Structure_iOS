//
//  AccountManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 17/6/25.
//

import Foundation

enum AccountTypeEnum: String {
    case generalAccount = "GENERAL_ACCOUNT"
    case counterAccount = "COUNTER_ACCOUNT"
    case stationAccount = "STATION_ACCOUNT"
    case cooperateAccount = "COOPERATE_ACCOUNT"
}

class AccountManager{
    
    static let shared = AccountManager()
    private init() {}
    
    private let accountType = "accountType"
    
    func setCurrentAccount(_ account: AccountTypeEnum){
        UserDefaults.standard.setValue(account.rawValue, forKey: accountType)
    }
    
    func getCurrentAccount() -> AccountTypeEnum {
        let accountType = UserDefaults.standard.string(forKey: accountType) ?? AccountTypeEnum.generalAccount.rawValue
        let currentType = AccountTypeEnum(rawValue: accountType) ?? .generalAccount
        return currentType
    }
}
