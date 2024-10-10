//
//  HomeVM.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/9/24.
//

import Foundation

class HomeVM{
    
    static func getWalet(success: @escaping (_ response: Response) -> Void){
        
        ApiManager.apiConnection(url: Endpoint.wallet)
        { ( res : Response) in
            
            AlertMessage.shared.isSuccessfulResponse(res) {
                success(res)
            }
        }
    }
    
    static func getUserInfor(success: @escaping (_ response: Response) -> Void){
        
        ApiManager.apiConnection(url: Endpoint.userInfor)
        { ( res : Response) in
            
            AlertMessage.shared.isSuccessfulResponse(res) {
                success(res)
            }
        }
    }
}
