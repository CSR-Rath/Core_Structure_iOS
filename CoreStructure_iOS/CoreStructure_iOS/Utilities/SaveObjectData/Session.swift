//
//  Session.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

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



class Session {
    static let shared = Session()
    let preference = UserDefaults.standard
    
    //MARK: ==================== Save User And Get Date Save User ==============
    
    func saveUser(data: [CheckPhoneNumberResult]) {
        preference.save(object: data, forKey: "saveData")
    }
    
    func getInfoUser()-> [CheckPhoneNumberResult]? {
        guard let user = preference.object([CheckPhoneNumberResult].self, with: "saveData") else {
            return [CheckPhoneNumberResult]()
        }
        return user
    }
    
    //MARK: ====================================================================

    func saveUserData(data: UserInforModel) {
        preference.save(object: data, forKey: AppCostants.userInfor)
    }
    
    
    func getUserAPI()-> UserInforModel {
        guard let user = preference.object(UserInforModel.self, with: AppCostants.userInfor) else {
            return UserInforModel()
        }
        return user
    }
    
    //MARK: ====================================================================
    
}

extension UserDefaults{
    //MARK: Save array object
    public func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    //MARK: Save object
    public func save<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
