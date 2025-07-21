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
    case infoUserApp = "master/transaction?page=1&size=10"
    case infoUserApp2 = "master/transaction?page=2&size=20"
    case infoUserApp3 = "master/transaction?page=3&size=30"
    
    case products1 = "products/?page=1"
    case products2 = "products/?page=2"
    case products3 = "products/?page=3"
    case login = "login/"
    case refreshToken = "token/refresh/"//"token/refresh/"
     
}



