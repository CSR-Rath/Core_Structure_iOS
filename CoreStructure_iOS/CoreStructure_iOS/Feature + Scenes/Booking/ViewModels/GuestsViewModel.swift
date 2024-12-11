//
//  GuestsViewModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 3/12/24.
//

import UIKit

class GuestsViewModel{
    
    private let endPoint =  Endpoints.guests
    static let shared = GuestsViewModel()
    
    func getGuestsList(success: @escaping (_ response: GuestListResponse) -> Void){
        
        ApiManager.shared.apiConnection(url: endPoint)
        { (res: GuestListResponse) in
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
    func post_put_Guests(param: Encodable, method: HTTPMethod, id: Int = 0,
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
}
