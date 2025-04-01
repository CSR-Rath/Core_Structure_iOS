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
    private let itemOneDropModel = "itemOneDropModel"
    private let itemTwoDropModel = "itemTwoDropModel"
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
    
    
    func saveItemOneDropModel(data: [ItemDragDropModel]) {
        saveObject(object: data, forKey: itemOneDropModel)
    }
    
    func saveItemTwoDropModel(data: [ItemDragDropModel]) {
        saveObject(object: data, forKey: itemTwoDropModel)
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
    
    func getItemOneDropModel() -> [ItemDragDropModel]? {
        return getObject([ItemDragDropModel].self, with: itemOneDropModel) ?? []
    }
    
    func getItemTwoDropModel() -> [ItemDragDropModel]? {
        return getObject([ItemDragDropModel].self, with: itemTwoDropModel) ?? []
    }
    
}


// Remove data
extension DataManager {
    
    func removeItemOneDropModel(){
        userDefaults.removeObject(forKey: itemOneDropModel)
    }
    
    func removeItemTowDropModel(){
        userDefaults.removeObject(forKey: itemTwoDropModel)
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




