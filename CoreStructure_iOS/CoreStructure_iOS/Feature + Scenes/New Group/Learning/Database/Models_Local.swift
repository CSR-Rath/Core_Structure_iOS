//
//  Models.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/11/24.
//

import UIKit
import RealmSwift

class User: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var lastName: String = ""
    @Persisted var firstName: String = ""
    @Persisted var password: String = ""
    @Persisted var phoneNumber: String = ""
    @Persisted var storeUser: Store? = nil
    
    
    override static func primaryKey() -> String? {
         return "phoneNumber"  // Set phoneNumber as the primary key
     }
}

class Store: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var password: String = ""
    @Persisted var phoneNumber: String = ""
    
    override static func primaryKey() -> String? {
         return "phoneNumber"  // Set phoneNumber as the primary key
     }
    
}


// MARK: - Product Model

class Product: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var descriptionText: String = ""
    @Persisted var price: Double = 0.0
    @Persisted var stockQuantity: Int = 0
    @Persisted var photo: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}


// MARK: - CartItem Model

class CartItem : Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var product: ProductCart?  // Reference to Product
    @Persisted var quantity: Int = 1
    @Persisted var create: Double = Date().timeIntervalSince1970
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ProductCart: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var idHelp: String = ""
    @Persisted var name: String = ""
    @Persisted var price: Double = 0.0
    @Persisted var photo: String = ""
    @Persisted var stockQuantity: Int = 0
}



class Transaction: Object {
    
    @Persisted var id: String = UUID().uuidString
    @Persisted var cartItems: List<CartItem> = List<CartItem>() // List of CartItems in the transaction
    @Persisted var totalAmount: Double = 0.0
    @Persisted var date: Date = Date()
    @Persisted var paymentType: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}





