//
//  AESUtils.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import Foundation
import CommonCrypto
import CryptoKit

class EncryptionManager{
    
    static let shared = EncryptionManager()
    
    func encryptAES(jsonString: String,
                       key256: String,
                       vector: String) -> String {
        
        let result = jsonString.aesEncrypt(key: key256, vector: vector)
        
        // Remove whitespaces if encryption result is not nil
        let cleanResult = result?.filter { !$0.isWhitespace } ?? ""
        print("🔐 Encrypted AES ==> \(cleanResult)")
        
        return cleanResult
    }
    
    func decryptAES(value: String,
                       key256: String,
                       vector: String) -> String {
        let result = value.aesDecrypt(key: key256,
                                      vector: vector)
        
        // Remove whitespaces if encryption result is not nil
        let cleanResult = result?.filter { !$0.isWhitespace } ?? ""
        print("🔓 Decrypted AES ==> \(cleanResult)")
        
        return cleanResult
    }
    
    func generateHMAC_SHA512(sequence: String, key: String) -> String {
        guard let keyData = key.data(using: .utf8),
              let messageData = sequence.data(using: .utf8) else {
            return ""
        }
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        keyData.withUnsafeBytes { keyBytes in
            messageData.withUnsafeBytes { messageBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512),
                       keyBytes.baseAddress,
                       keyData.count,
                       messageBytes.baseAddress,
                       messageData.count,
                       &digest)
            }
        }
        
        let data = Data(digest).base64EncodedString()
        print("🧾 HMAC-SHA512: \(data)")
        
        return data
    }
}


extension String {
    
    fileprivate func aesEncrypt(key: String,
                                vector: String,
                                options: Int = kCCOptionPKCS7Padding) -> String? {
        
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = self.data(using: String.Encoding.utf8),
           let cryptData = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
            
            let keyLength = size_t(kCCKeySizeAES256)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options: CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      vector,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                
                return base64cryptString
            }
            else {
                return nil
            }
        }
        
        return nil
    }
    
    fileprivate func aesDecrypt(key: String,
                                vector: String,
                                options: Int = kCCOptionPKCS7Padding) -> String? {
        
        if let keyData = key.data(using: .utf8),
           let data = Data(base64Encoded: self),
           let cryptData = NSMutableData(length: Int(data.count) + kCCBlockSizeAES128) {
            
            let keyLength = size_t(kCCKeySizeAES256)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options: CCOptions = UInt32(options)
            
            var numBytesDecrypted: size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      vector,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesDecrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesDecrypted)
                if let decryptedString = String(data: cryptData as Data, encoding: .utf8) {
                    return decryptedString
                }
            }
            else{
                return nil
            }
        }
        
        return nil
    }
}


//MARK: - Simple, How to use it.

struct Auth: Codable {
    let phoneNumber: String
    let password: String
}

struct TransferRequest: Codable {
    var timestamp: String
    var fromAccountNumber: String
    var toAccountNumber: String
    var counterId: String
    var quantityLiter: String
    var hash: String
}

struct EncrypoitAES: Codable{
    var data: String
}



class HowToUseCryptoHelper {

    /// Example: Encrypt an `Auth` object
    func useEncryptionAES() {
        let auth = Auth(phoneNumber: "081856090", password: "11111")
        guard let jsonString = CodableConverter.shared.codableToJSONString(auth) else {
            print("❌ Failed to convert Auth to JSON")
            return
        }

        let encrypted = EncryptionManager.shared.encryptAES(jsonString: jsonString,
                                                key256: CryptoConfig.Auth.key,
                                                vector: CryptoConfig.Auth.iv)
        let payload = EncrypoitAES(data: encrypted)
        print("✅ Encrypted AES: \(payload)")
    }

    /// Example: Decrypt an AES string (You must pass encrypted string from server or test)
    func useDecryptionAES(encryptedString: String) {
        let decrypted = EncryptionManager.shared.decryptAES(value: encryptedString,
                                                key256: CryptoConfig.Auth.key,
                                                vector: CryptoConfig.Auth.iv)
        print("✅ Decrypted JSON: \(decrypted )")
    }

    /// Create encrypted transfer request with HMAC hash
    func generateTransferPayload(from request: TransferRequest) -> String {
        // 1. Build hash
        let sequence = "\(request.timestamp)\(request.fromAccountNumber)\(request.toAccountNumber)\(request.counterId)\(request.quantityLiter)"
        let hash = EncryptionManager.shared.generateHMAC_SHA512(sequence: sequence, key: CryptoConfig.Transfer.key)

        // 2. Add hash to request
        var updatedRequest = request
        updatedRequest.hash = hash

        // 3. Convert to JSON
        guard let jsonString = CodableConverter.shared.codableToJSONString(updatedRequest) else {
            return  ""
        }

        // 4. Encrypt JSON with Transfer key/iv
        let encrypted = EncryptionManager.shared.encryptAES(jsonString: jsonString,
                                                key256: CryptoConfig.Transfer.key,
                                                vector: CryptoConfig.Transfer.iv)
        return encrypted
    }
}
