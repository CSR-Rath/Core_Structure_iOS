//
//  SaveData.swift
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



class SaveData {
    static let shared = SaveData()
    let preference = UserDefaults.standard
    
    //MARK: ==================== Save User And Get Date Save User ==============
    
    func saveUser(data: [CheckPhoneNumberResult]) {
        preference.saveObject(object: data, forKey: "saveData")
    }
    
    func getInfoUser()-> [CheckPhoneNumberResult]? {
        guard let user = preference.getObject([CheckPhoneNumberResult].self, with: "saveData") else {
            return [CheckPhoneNumberResult]()
        }
        return user
    }
    
    //MARK: ====================================================================

    func saveUserData(data: UserInforModel) {
        preference.saveObject(object: data, forKey: AppCostants.userInfor)
    }
    
    
    func getUserAPI()-> UserInforModel {
        guard let user = preference.getObject(UserInforModel.self, with: AppCostants.userInfor) else {
            return UserInforModel()
        }
        return user
    }
    
    //MARK: ====================================================================
    
}


