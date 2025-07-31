//
//  LoginViewModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 31/7/25.
//

import Foundation

class LoginViewModel{
    
    var onSuccessLogin: (()->Void)?
    
    func login(username: String, password: String){
        
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        ApiManager.shared.apiConnection(url: .login,
                                        method: .POST,
                                        param: parameters,
                                        headers: nil
                                       ) { [weak self] (res: LoginModel) in
            
            UserDefaults.standard.setValue(res.access, forKey: AppConstants.token)
            UserDefaults.standard.setValue(res.refresh, forKey: AppConstants.refreshToken)
            UserDefaults.standard.setValue(true, forKey: AppConstants.loginSuuccess)
            self?.onSuccessLogin?()
        }
    }
}
