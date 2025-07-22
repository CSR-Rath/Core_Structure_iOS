//
//  APITheSameTimeViewModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/7/25.
//

import Foundation

class APITheSameTimeViewModel {
 
    var productList1: ProductListResponse?
    var productList2: ProductListResponse?
    var productList3: ProductListResponse?
    
    var onDataUpdated: (() -> Void)?
    
    func fetchApiTheSameTime() {
        let group = DispatchGroup() // iOS 8+ DispatchGroup -> iOS 15+  withTaskGroup
        
        group.enter()
        ApiManager.shared.apiConnection(url: .products1) { (res: ProductListResponse) in
            DispatchQueue.main.async { [self] in
                self.productList1 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .products2) { (res: ProductListResponse) in
            DispatchQueue.main.async {
                self.productList2 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .products3) { (res: ProductListResponse) in
            DispatchQueue.main.async {
                self.productList3 = res
            }
            group.leave()
        }

        group.notify(queue: .main) {
            self.onDataUpdated?()
            print("✅ All APIs completed")
        }
    }
}


class APITheSameTimeViewModel {

    var productList1: ProductListResponse?
    var productList2: ProductListResponse?
    var productList3: ProductListResponse?

    var onDataUpdated: (() -> Void)?

    func fetchApiTheSameTime() async {
        async let result1 = ApiManager.shared.apiConnectionAsync(url: .products1)
        async let result2 = ApiManager.shared.apiConnectionAsync(url: .products2)
        async let result3 = ApiManager.shared.apiConnectionAsync(url: .products3)

        do {
            let (res1, res2, res3) = try await (result1, result2, result3)

            // Assign to properties on the main thread
            await MainActor.run {
                self.productList1 = res1
                self.productList2 = res2
                self.productList3 = res3
                self.onDataUpdated?()
                print("✅ All APIs completed")
            }
        } catch {
            print("❌ Failed to fetch data: \(error)")
        }
    }
}
