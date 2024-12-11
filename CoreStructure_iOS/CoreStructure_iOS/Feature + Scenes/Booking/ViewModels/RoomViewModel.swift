//
//  RoomViewModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 5/12/24.
//

import UIKit

class RoomViewModel {
    

    static let shared = RoomViewModel()
    private let endPoint =  Endpoints.room
    
    func getRoomList(success: @escaping (_ response: RoomList) -> Void){
        
        ApiManager.shared.apiConnection(url: endPoint)
        { (res: RoomList) in
            success(res)
        }
    }
    
    
    func deteleGeusts(id: Int, success: @escaping (_ response: Response) -> Void){
        ApiManager.shared.apiConnection(url: endPoint+"/\(id)",
                                        method: .DELETE)
        {(res : Response) in
            success(res)
        }
    }
    
    // MARK: - Post - Put (Geusts)
    func post_put_Room(param: Encodable, method: HTTPMethod, id: Int = 0,
                    success: @escaping (_ response: GuestPostResponse) -> Void){
        
        var endpoint = endPoint
        
        if id != 0{
            endpoint = endPoint+"/\(id)"
        }
        
        ApiManager.shared.apiConnection(url: endpoint,
                                        method: method,
                                        modelCodable: param)
        { (res: GuestPostResponse) in
            
            success(res)
        }
    }
    
    
//    func getRoomTypeByID(id: Int, success: @escaping (_ response: RoomType) -> Void){
//        ApiManager.shared.apiConnection(url: endPoint+"/\(id)")
//        {(res : RoomType) in
//            success(res)
//        }
//    }
}
