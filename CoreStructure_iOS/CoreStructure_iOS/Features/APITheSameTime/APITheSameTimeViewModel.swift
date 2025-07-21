//
//  APITheSameTimeViewModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/7/25.
//

import Foundation

class APITheSameTimeViewModel {
 
    var userInfoModel1: APITheSameModel?
    var userInfoModel2: APITheSameModel?
    var userInfoModel3: APITheSameModel?
    
    var onDataUpdated: (() -> Void)?
    
    func fetchApiTheSameTime() {
        let group = DispatchGroup() // iOS 8+ DispatchGroup -> iOS 15+  withTaskGroup
        
        group.enter()
        ApiManager.shared.apiConnection(url: .infoUserApp) { (res: APITheSameModel) in
            DispatchQueue.main.async { [self] in
                userInfoModel2 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .infoUserApp2) { (res: APITheSameModel) in
            DispatchQueue.main.async {
                self.userInfoModel2 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .infoUserApp3) { (res: APITheSameModel) in
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
