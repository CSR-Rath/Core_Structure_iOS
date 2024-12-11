//
//  DatabaseManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/11/24.
//

import Foundation
import RealmSwift

// MARK: - Database Operations

class DatabaseManager {
    
    let realm = try! Realm()
    
    func getProductById(_ id: String) -> Product? {
         return realm.object(ofType: Product.self, forPrimaryKey: id)
     }
    
    // Create Product
    func createProduct(name: String,
                       description: String = "",
                       price: Double,
                       stockQuantity: Int,
                       photo: String
    ) {
        let product = Product()
        product.name = name
        product.descriptionText = description
        product.price = price
        product.stockQuantity = stockQuantity
        product.photo = photo
        
        try! realm.write {
            realm.add(product)
        }
    }
    
    func updateProduct(id: String,
                       name: String,
                       description: String = "",
                       price: Double,
                       stockQuantity: Int,
                       photo: String 
    ) {
        
        if let product = realm.object(ofType: Product.self, forPrimaryKey: id) {
            try! realm.write {
                product.name = name
                product.descriptionText = description
                product.price = price
                product.stockQuantity = stockQuantity
                product.photo = photo
            }
        } else {
            print("Product with ID \(id) not found.")
        }
    }
    
    func deleteProduct(byId id: String) {
        if let productToDelete = realm.object(ofType: Product.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(productToDelete)
            }
        } else {
            print("Product with id \(id) not found.")
        }
    }

    // Fetch All Products
    func fetchProducts() -> [Product] {
        return Array(realm.objects(Product.self).reversed())
    }
    
    
    // Fetch All Products
    func fetchUser() -> [User] {
        return Array(realm.objects(User.self).reversed())
        
    }
    
    func fetchUserSore() -> [Store] {
        return Array(realm.objects(Store.self).reversed())
        
    }
    
    // Fetch All Products
    func fetchTransaction() -> [Transaction] {
        return Array(realm.objects(Transaction.self).reversed())
        
    }





    func getLastTransactionByIndex() -> Transaction? {
        // Get the default Realm
        let realm = try! Realm()

        // Fetch all transactions
        let transactions = realm.objects(Transaction.self)

        // Check if there are any transactions
        if transactions.count > 0 {
            // Return the last transaction using the last index
            return transactions[transactions.count - 1]
        } else {
            return nil // No transactions found
        }
    }
    
    func getFirstTransaction() -> Transaction? {
        // Get the default Realm
        let realm = try! Realm()

        // Fetch transactions and limit to the first result
        let firstTransaction = realm.objects(Transaction.self).first

        return firstTransaction
    }
    
    
    
    func saveUser(firstName: String,
                  lastName: String,
                  password: String,
                  phoneNumber: String,
                  createSuccess: @escaping () -> Void,
                  alreadyPhone: @escaping () -> Void) {
        let realm = try! Realm()

        // Check if a user with the same phone number already exists
        if realm.object(ofType: User.self, forPrimaryKey: phoneNumber) != nil {
            
            alreadyPhone()
        } else {
            // Create a new user instance
            let newUser = User()
            newUser.firstName = firstName
            newUser.lastName = lastName
            newUser.password = password
            newUser.phoneNumber = phoneNumber

            // Write the new user to Realm
            do {
                try realm.write {
                    realm.add(newUser)
                    createSuccess()
                }
                print("User saved successfully!")
            } catch {
                print("Error saving user: \(error)")
            }
        }
    }
    
    func saveUserStore(
                  name: String,
                  password: String,
                  phoneNumber: String,
                  createSuccess: @escaping () -> Void,
                  alreadyPhone: @escaping () -> Void) {
        let realm = try! Realm()

        // Check if a user with the same phone number already exists
        if realm.object(ofType: Store.self, forPrimaryKey: phoneNumber) != nil {
            alreadyPhone()
        } else {
            // Create a new user instance
            let newUser = Store()
            newUser.name = name
            newUser.password = password
            newUser.phoneNumber = phoneNumber

            // Write the new user to Realm
            do {
                try realm.write {
                    realm.add(newUser)
                    createSuccess()
                }
                print("User saved successfully!")
            } catch {
                print("Error saving user: \(error)")
            }
        }
    }
    
    
    
    func processPayment(for cartItems: [CartItem], paymentType: String) {
        let realm = try! Realm()
        
        
        do {
            try realm.write {
                let transaction = Transaction() // Create a new transaction
                
                var totalAmount: Double = 0.0
                for cartItem in cartItems {
                    
                    
                    if let product = cartItem.product {
                        // Ensure there is enough stock to reduce
                        if product.stockQuantity >= cartItem.quantity {
                            // Decrease the stock quantity
                            product.stockQuantity -= cartItem.quantity
                            // Add the cart item to the transaction
                            transaction.cartItems.append(cartItem)
                            // Calculate the total amount
                            totalAmount += product.price * Double(cartItem.quantity)
                        } else {
                            print("Not enough stock available for \(product.name)")
                            return // Exit if stock is insufficient for any item
                        }
                    }
                    
//                    updateStockQuantity(productId: cartItem.product?.idHelp ?? "", newQuantity: cartItem.quantity )
                }
                
                // Set total amount and date for the transaction
                transaction.totalAmount = totalAmount
                transaction.date = Date()
                transaction.paymentType = paymentType
                
                // Save the transaction to Realm
                realm.add(transaction)
                
            }
        } catch {
            print("Error processing payment: \(error)")
        }
    }
    
    
    func updateStockQuantity(productId: String, newQuantity: Int) {
        // Get the default Realm
        // Begin a write transaction
        try! realm.write {
            // Find the product with the specified id
            if let product = realm.object(ofType: Product.self, forPrimaryKey: productId) {
                // Update the stock quantity
                product.stockQuantity -= newQuantity
            } else {
                print("Product not found")
            }
        }
    }
    
}




