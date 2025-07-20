//
//  APITheSameTimeViewModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/7/25.
//

import Foundation

struct User1: Codable {
    let id: Int
    let name: String
    let email: String
}

struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct ResponseModel:Codable {
    var status: Int?
    var message: String?
}

struct UserInfoModel : Codable{
    var results : ResultsUserInfoModel?
    var response : ResponseModel?
    
}

struct ResultsUserInfoModel : Codable{
    var name: String?
    var phone: String?
    var photo: String?
    var number: String?
    var verify: Bool?
    var gender: String?
    var dob: String?
    var nid: String?
    var email: String?
}

class APITheSameTimeViewModel {
 
        var users: [User1] = []
        var posts: [Post] = []
    
    var userInfoModel1: ApiResponse?
    var userInfoModel2: ApiResponse?
    var userInfoModel3: ApiResponse?
    
    
    var onDataUpdated: (() -> Void)?   // Closure property to notify data updated
    
    func fetchUsersAndPosts() {
        let group = DispatchGroup()
        
        group.enter()
        ApiManager.shared.apiConnection(url: .infoUserApp) { (res: ApiResponse) in
            DispatchQueue.main.async { [self] in
                userInfoModel2 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .infoUserApp2) { (res: ApiResponse) in
            DispatchQueue.main.async {
                self.userInfoModel2 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .infoUserApp3) { (res: ApiResponse) in
            DispatchQueue.main.async {
                self.userInfoModel3 = res
            }
            group.leave()
        }


        group.notify(queue: .main) {
            self.onDataUpdated?()
            print("✅ All APIs completed")
        }
    }
    
}
