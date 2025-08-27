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
        ApiManager.shared.apiConnection(url: .apiFreePosts) { (res: ProductListResponse) in
            DispatchQueue.main.async {
                self.productList1 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .apiFreePosts) { (res: ProductListResponse) in
            DispatchQueue.main.async {
                self.productList2 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .apiFreePosts) { (res: ProductListResponse) in
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





//@MainActor
//class ViewModel {
//
////    @Published var posts = [PostModel]()
////    var posts = [PostModel]()
//    var onDataUpdated: (() -> Void)?
////
////    func fetchPosts() {
////        Task {
////            if let result: [PostModel] = await fetch(endpoint: .apiFreePosts) {
////                self.posts = result
////                self.onDataUpdated?()
////            }
////        }
////    }
////
////    private func fetch<T: Codable>(endpoint: EndpointEnum) async -> T? {
////        await withCheckedContinuation { continuation in
////            ApiManager.shared.apiConnection(url: endpoint) { (res: T) in
////                continuation.resume(returning: res)
////            }
////        }
////    }
//
//
//        // Published property to update the UI
//        @Published var posts: [PostModel] = []
//        @Published var errorMessage: String?
//
//        // MARK: - Fetch Posts
//        func fetchPosts() {
//            Task {
//                do {
//                    let fetchedPosts: [PostModel] = try await ApiManagerAsync.shared.currentTask?.currentRequest
//
//                    // Update UI
//
//                    self.posts = fetchedPosts
//                    self.errorMessage = nil
//                    onDataUpdated?()
//
//                } catch {
//                    // Handle errors
//                    self.errorMessage = "Failed to fetch posts: \(error.localizedDescription)"
//                    print(error)
//                }
//            }
//        }
//}





struct PostModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}




//@MainActor
//class ViewModel: ObservableObject {
//    var posts: [PostModel]?
//    var onDataUpdated: (() -> Void)?
//
//    func fetchPosts() {
//        Task {
//            do {
//                posts = try await ApiManagerAsyncAwait.shared.request(endpoint: .apiFreePosts)
//                onDataUpdated?()
//            } catch {
//                print("Error: ", error.localizedDescription)
//            }
//        }
//    }
//}


@MainActor
class ViewModel: ObservableObject {
    var posts: [PostModel]?
    var comments: [PostModel]? // example second API
    var onDataUpdated: (() -> Void)?
    
    func asyncCall() {
        Task {
            do {
                // Start multiple requests concurrently
                async let postsRequest: [PostModel] = ApiManagerAsyncAwait.shared.request(endpoint: .apiFreePosts)
                async let commentsRequest: [PostModel] = ApiManagerAsyncAwait.shared.request(endpoint: .apiFreePosts)
                
                // Await results together
                let (postsResult, commentsResult) = try await (postsRequest, commentsRequest)
                
                // Assign results
                self.posts = postsResult
                self.comments = commentsResult
                
                // Notify UI
                onDataUpdated?()
                
            } catch {
                print("Error fetching data: ", error.localizedDescription)
            }
        }
    }
    
    func syncCall(){
        Task {
            do {
                // First request
                let postsResult: [PostModel]? = try await ApiManagerAsyncAwait.shared.request(endpoint: .apiFreePosts)
                
                // Second request (starts after first finishes)
                let commentsResult: [PostModel]? = try await ApiManagerAsyncAwait.shared.request(endpoint: .apiFreePosts)
                
                self.posts = postsResult
                self.comments = commentsResult
                
                // is called once after both finish.
                onDataUpdated?()
                
            } catch {
                print("Error fetching data: ", error.localizedDescription)
            }
        }
        
    }
    
    
    func fetchWithTaskGroup() {
        
        
        Task {
            do {
                // Create a task group
                try await withThrowingTaskGroup(of: (String, [PostModel]).self) { group in
                    
                    // Add first API request
                    group.addTask {
                        let posts: [PostModel] = try await ApiManagerAsyncAwait.shared.request(endpoint: .apiFreePosts)
                        return ("posts", posts)
                    }
                    
                    // Add second API request
                    group.addTask {
                        let comments: [PostModel] = try await ApiManagerAsyncAwait.shared.request(endpoint: .apiFreePosts)
                        return ("comments", comments)
                    }
                    
                    // Collect results
                    var tempPosts: [PostModel]?
                    var tempComments: [PostModel]?
                    
                    for try await (key, result) in group {
                        if key == "posts" {
                            tempPosts = result
                            print("===> tempPosts")
                        }
                        if key == "comments" {
                            tempComments = result
                            print("===> tempComments")
                        }
                    }
                    
                    // Assign to properties
                    self.posts = tempPosts
                    self.comments = tempComments
                    
                    // Notify UI
                    onDataUpdated?()
                }
            } catch {
                print("Error fetching data with TaskGroup: ", error.localizedDescription)
            }
        }
    }
    
}
