////
////  FirebaseManager.swift
////  CoreStructure_iOS
////
////  Created by Rath! on 4/4/25.
////
//
//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreInternal
//
//enum DBName: String {
//    case orders
//}
//
//class FirebaseManager {
//    
//    static let shared = FirebaseManager()
//    
////    private init() {}
//    
//    func saveDataFirebase<T: Encodable>(dbName: DBName, modelCodable: T, completion: @escaping (Bool) -> Void) {
//        let db = Firestore.firestore()
//        
//        do {
//            let encoder = JSONEncoder()
//            let modelData = try encoder.encode(modelCodable)
//            
//            if let modelDictionary = try JSONSerialization.jsonObject(with: modelData, options: .mutableContainers) as? [String: Any] {
//                
//                if let idValue = modelDictionary["id"] {
//                    let documentID = String(describing: idValue)
//                    
//                    db.collection(dbName.rawValue).document(documentID).setData(modelDictionary) { error in
//                        if let error = error {
//                            print("❌ Error saving data: \(error.localizedDescription)")
//                            completion(false)
//                        } else {
//                            print("✅ Data saved with ID = \(documentID)")
//                            completion(true)
//                        }
//                    }
//                } else {
//                    print("❌ Missing 'id' field in model.")
//                    completion(false)
//                }
//            }
//        } catch {
//            print("❌ Encoding error: \(error.localizedDescription)")
//            completion(false)
//        }
//    }
//    
//    func getAllData<T: Decodable>(dbName: DBName, modelType: T.Type, completion: @escaping ([T]?) -> Void) {
//        let db = Firestore.firestore()
//        
//        db.collection(dbName.rawValue).getDocuments { snapshot, error in
//            if let error = error {
//                print("❌ Error fetching all: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                completion([])
//                return
//            }
//            
//            var result: [T] = []
//            for doc in documents {
//                do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
//                    let model = try JSONDecoder().decode(T.self, from: jsonData)
//                    result.append(model)
//                } catch {
//                    print("❌ Decoding failed: \(error.localizedDescription)")
//                }
//            }
//            completion(result)
//        }
//    }
//    
//    func getDataById<T: Decodable>(dbName: DBName, documentID: String, modelType: T.Type, completion: @escaping (T?) -> Void) {
//        let db = Firestore.firestore()
//        
//        db.collection(dbName.rawValue).document(documentID).getDocument { snapshot, error in
//            if let error = error {
//                print("❌ Error getting document: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            
//            guard let data = snapshot?.data() else {
//                print("⚠️ Document not found")
//                completion(nil)
//                return
//            }
//            
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//                let model = try JSONDecoder().decode(T.self, from: jsonData)
//                completion(model)
//            } catch {
//                print("❌ Decoding error: \(error.localizedDescription)")
//                completion(nil)
//            }
//        }
//    }
//    
//    func updateDataById<T: Encodable>(dbName: DBName, documentID: String, updatedModel: T, completion: @escaping (Bool) -> Void) {
//        let db = Firestore.firestore()
//        
//        do {
//            let encoder = JSONEncoder()
//            let modelData = try encoder.encode(updatedModel)
//            
//            if let dataDict = try JSONSerialization.jsonObject(with: modelData, options: []) as? [String: Any] {
//                db.collection(dbName.rawValue).document(documentID).updateData(dataDict) { error in
//                    if let error = error {
//                        print("❌ Update failed: \(error.localizedDescription)")
//                        completion(false)
//                    } else {
//                        print("✅ Document updated with ID = \(documentID)")
//                        completion(true)
//                    }
//                }
//            }
//        } catch {
//            print("❌ Encoding error: \(error.localizedDescription)")
//            completion(false)
//        }
//    }
//    
//    func deleteById(dbName: DBName, modelID: Int, completion: @escaping (Bool) -> Void) {
//        let db = Firestore.firestore()
//        
//        db.collection(dbName.rawValue).whereField("id", isEqualTo: modelID).getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching document by id field: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            
//            guard let documents = snapshot?.documents, !documents.isEmpty else {
//                print("No matching documents found.")
//                completion(false)
//                return
//            }
//            
//            for document in documents {
//                db.collection(dbName.rawValue).document(document.documentID).delete { error in
//                    if let error = error {
//                        print("Error deleting: \(error.localizedDescription)")
//                        completion(false)
//                    } else {
//                        print("Deleted document with id field = \(modelID)")
//                        completion(true)
//                    }
//                }
//            }
//        }
//    }
//    
//    func deleteAllList(dbName: DBName, completion: @escaping (Bool) -> Void) {
//        let db = Firestore.firestore()
//        
//        db.collection(dbName.rawValue).getDocuments { snapshot, error in
//            if let error = error {
//                print("❌ Error getting documents: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                print("⚠️ No documents found.")
//                completion(false)
//                return
//            }
//            
//            let dispatchGroup = DispatchGroup()
//            var isSuccess = true
//            
//            for document in documents {
//                dispatchGroup.enter()
//                db.collection(dbName.rawValue).document(document.documentID).delete { error in
//                    if let error = error {
//                        print("❌ Error deleting document: \(error.localizedDescription)")
//                        isSuccess = false
//                    } else {
//                        print("🗑️ Deleted: \(document.documentID)")
//                    }
//                    dispatchGroup.leave()
//                }
//            }
//            
//            dispatchGroup.notify(queue: .main) {
//                print(isSuccess ? "✅ All documents deleted." : "⚠️ Some documents failed to delete.")
//                completion(isSuccess)
//            }
//        }
//    }
//}
////
////addButton.setTitle("Save", for: .normal)
////addButton.actionUIButton = {
////    let model = MakeOrderModel(
////        id: 1,
////        customerName: "Sophearath",
////        phoneNumber: "012345678",
////        created: Int(Date().timeIntervalSince1970),
////        products: [ProductModel(name: "iPhone", amount: 1200.0, qty: 1)],
////        delivery: 5.0,
////        location: "Phnom Penh"
////    )
////
////    FirebaseManager.shared.saveDataFirebase(dbName: .orders, modelCodable: model) { success in
////        print("Save result: \(success)")
////    }
////}
////
////submitButton2.setTitle("get all", for: .normal)
////submitButton2.actionUIButton = {
////    FirebaseManager.shared.getAllData(dbName: .orders, modelType: MakeOrderModel.self) { models in
////        print("Orders:", models ?? [])
////    }
////}
////
////submitButton3.setTitle("Fetched id", for: .normal)
////submitButton3.actionUIButton = {
////    
////    FirebaseManager.shared.getDataById(dbName: .orders, documentID: "1", modelType: MakeOrderModel.self) { model in
////        print("Fetched:", model!)
////    }
////}
////
////
////submitButton.setTitle("Up id", for: .normal)
////submitButton.actionUIButton =  {
////    let updated = MakeOrderModel(
////        id: 1,
////        customerName: "Rath Updated",
////        phoneNumber: "099999999",
////        created: Int(Date().timeIntervalSince1970),
////        products: [ProductModel(name: "MacBook", amount: 2000.0, qty: 1)],
////        delivery: 10.0,
////        location: "Siem Reap"
////    )
////
////    FirebaseManager.shared.updateDataById(dbName: .orders, documentID: "1", updatedModel: updated) { success in
////        print("Update:", success)
////    }
////
////    
////}
////
////submitButton4.actionUIButton = {
////    FirebaseManager.shared.deleteById(dbName: .orders, modelID: 1) { s in
////        
////    }
////}
////}
