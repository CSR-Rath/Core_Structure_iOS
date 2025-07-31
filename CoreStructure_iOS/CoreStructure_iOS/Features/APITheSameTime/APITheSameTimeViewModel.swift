//
//  APITheSameTimeViewModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/7/25.
//

import Foundation

class APITheSameTimeViewModel_iOS13 {
    
    var productList1: ProductListResponse?
    var productList2: ProductListResponse?
    var productList3: ProductListResponse?
    
    var onDataUpdated: (() -> Void)?
    
    func fetchApiTheSameTime() {
        let group = DispatchGroup()
        
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


@MainActor
class APITheSameTimeViewModel {
    
    var productList1: ProductListResponse1?
    var productList2: ProductListResponse2?
    var productList3: ProductListResponse?
    
    var onDataUpdated: (() -> Void)?
    
    func fetchApiTheSameTime() {
        Task {
            await fetchAllProducts()
        }
    }
    
    private func fetchAllProducts() async {
        await withTaskGroup(of: (Int, Any?).self) { group in
            
            group.addTask {
                let result: ProductListResponse1? = await self.fetch(endpoint: .products1)
                return (1, result)
            }
            
            group.addTask {
                let result: ProductListResponse2? = await self.fetch(endpoint: .products2)
                return (2, result)
            }
            
            group.addTask {
                let result: ProductListResponse? = await self.fetch(endpoint: .products3)
                return (3, result)
            }
            
            for await (index, result) in group {
                switch index {
                case 1: self.productList1 = result as? ProductListResponse1
                    
                    print("Handle response here.")
                case 2: self.productList2 = result as? ProductListResponse2
                    
                    print("Handle response here.")
                case 3: self.productList3 = result as? ProductListResponse
                    
                    print("Handle response here.")
                default: break
                }
            }
        }
        
        self.onDataUpdated?()
    }
    
    
    private func fetch<T: Codable>(endpoint: EndpointEnum) async -> T? {
        await withCheckedContinuation { continuation in
            ApiManager.shared.apiConnection(url: endpoint) { (res: T) in
                continuation.resume(returning: res)
            }
        }
    }
}


//@MainActor
class SingleCallApiViewModel {
    var productList1: ProductListResponse?
    var onDataUpdated: (() -> Void)?
    
    func fetchProduct() {
        Task {
            let result: ProductListResponse? = await fetch(endpoint: .products1)
            self.productList1 = result
            self.onDataUpdated?()
        }
    }
    
    private func fetch<T: Codable>(endpoint: EndpointEnum) async -> T? {
        await withCheckedContinuation { continuation in
            ApiManager.shared.apiConnection(url: endpoint) { (res: T) in
                continuation.resume(returning: res)
            }
        }
    }
}
