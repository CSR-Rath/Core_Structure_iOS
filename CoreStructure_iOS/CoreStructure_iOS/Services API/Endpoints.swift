//
//  Endpoints.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import Foundation

enum EndpointEnum: String {
    case test = "test"
    case wallet = "wallet"
    case userInfor = "userInfor"
    case guests = "geusts"
    case room = "rooms"
    case roomType = "room_types"
    case reservations = "reservations"
    
    case getUsers = "users"
    case getPosts = "posts"
    case refreshToken = "user/auth/refresh-token" //auth/refresh-token"
    case infoUserApp = "master/transaction?page=1&size=10"
    case infoUserApp2 = "master/transaction?page=2&size=20"
    case infoUserApp3 = "master/transaction?page=3&size=30"
     
}


struct ApiResponse: Codable {
    var page: Int?
    var size: Int?
    var total: Int?
    var totalPage: Int?
    var response: ResponseModel?
}
