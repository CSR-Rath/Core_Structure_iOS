//
//  AppConstant.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/10/24.
//

import Foundation
import UIKit


//MARK: - key UserDefaults
 struct AppConstants{
    
    static let loginSuccesFull = "loginSuccesFull"
    static let saveTimer = "saveTimer"
    static let userInfor = "userInfor"
    
    static let keyboradHeight = "keyboradHeight"
    
}


//MARK: - UserDefaults (key name)
struct KeyUser{
    static let token = "token"
    static let refreshToken = "refreshToken"
    static let loginSuccesFull = "loginSuccesFull"
    
    static let userRole = "userRole"
    static let userType = "userType"
}


extension UserDefaults{
    
   static let userType = UserDefaults.standard.string(forKey: KeyUser.userType)
   static let userRole = UserDefaults.standard.string(forKey: KeyUser.userRole)
   static let loginSuccesFull = UserDefaults.standard.bool(forKey: KeyUser.loginSuccesFull)
   
    
}
