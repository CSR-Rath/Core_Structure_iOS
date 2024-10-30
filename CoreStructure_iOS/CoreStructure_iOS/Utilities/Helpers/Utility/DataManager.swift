//
//  SaveData.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

class DataManager {
    
    static let shared = DataManager() // Singleton pattern
    private let userDefaults = UserDefaults.standard
    
    private let userInforKey = "userInfor"
    private let phoneNumberKey = "phoneNumber"
    
    private let dragDropMenu = "dragDropMenu"
}

// MARK: - Save object
extension DataManager {
    
    func saveDragDropMenu(data: [MenuListModel]) {
        saveObject(object: data, forKey: dragDropMenu)
    }
    
    func saveUserData(data: UserInforModel) {
        saveObject(object: data, forKey: userInforKey)
    }
    
    func saveUser(data: [CheckPhoneNumberResult]) {
        saveObject(object: data, forKey: phoneNumberKey)
    }
}

// MARK: - Get object
extension DataManager {
    func getDragDropMenu() -> [MenuListModel]? {
        return getObject([MenuListModel].self, with: dragDropMenu) ?? []
    }
    
    func getInfoUser() -> [CheckPhoneNumberResult]? {
        return getObject([CheckPhoneNumberResult].self, with: phoneNumberKey) ?? []
    }
    
    func getUserAPI() -> UserInforModel {
        return getObject(UserInforModel.self, with: userInforKey) ?? UserInforModel()
    }
}

// MARK: - Object Storage Functions
extension DataManager {
    
    // MARK: Get Object
    private func getObject<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }
    
    // MARK: Save Object
    private func saveObject<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        userDefaults.set(data, forKey: key)
    }
}





struct UserInforModel: Codable{
    var name: String = "Rath"
    var age: Int = 21
    var gender: String = "M"
    var address: String = "Phnom Penh"
}

struct AppleAuthorizeResult: Codable{
    
}


struct CheckPhoneNumberResult: Codable{
    
}



