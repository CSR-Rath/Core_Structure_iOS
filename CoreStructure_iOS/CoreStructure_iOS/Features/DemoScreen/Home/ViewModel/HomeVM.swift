//
//  HomeVM.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/9/24.
//

import Foundation

class HomeVM{
    
    static func getWalet(success: @escaping (_ response: Response) -> Void){
        
//        ApiManager.shared.apiConnection(url: .wallet)
//        { ( res : Response) in
//            
//            AlertMessage.shared.isSuccessfulResponse(res) {
//                success(res)
//            }
//        }
    }
    
    static func getUserInfor(success: @escaping (_ response: Response) -> Void){
        
//        ApiManager.shared.apiConnection(url: .userInfor)
//        { ( res : Response) in
//            
//            AlertMessage.shared.isSuccessfulResponse(res) {
//                success(res)
//            }
//        }
    }
}


class ManagerViewModel{
    
    var page: Int = 0
    var size: Int = 12
    var data: [String] = []
    
    func managerViewModel(){
//        ApiManager.shared.apiConnection(url: .guests)
//        { [self] (res: Response) in
//            
//            if page == 0{
//                data = res.list
//            }else{
//                data += res.list
//            }
//            
//        }
    }
    
}
