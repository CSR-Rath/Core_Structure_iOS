//
//  AESUtils.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import Foundation
import CommonCrypto
import CryptoKit

//MARK: - How to use it.
let passcode = "123456"
let encryption = AESUtils.shared.encryptionAES(value: passcode,
                                               key256: .paymentKey,
                                               initializationVector: .paymentVector)
enum KeyNum {
    case paymentKey

    var value: String {
        switch self {
        case .paymentKey:
            return AppConfiguration.shared.paymentKey
        }
    }
}

enum IVectorEnum {
    case paymentVector

    var value: String {
        switch self {
        case .paymentVector:
            return AppConfiguration.shared.paymentVector
        }
    }
}

class AESUtils{
    
    static let shared = AESUtils()
    
    func encryptionAES(value: String,
                       key256: KeyNum,
                       initializationVector: IVectorEnum) -> String {
        let result = value.aesEncrypt(key: key256,
                                      initializationVector: initializationVector)
        return result ?? ""
    }
    
    func decryptionAES(value: String,
                       key256: KeyNum,
                       initializationVector: IVectorEnum) -> String {
        let result = value.aesDecrypt(key: key256,
                                      initializationVector: initializationVector)
        return result ?? ""
    }
}

extension String {
    
    fileprivate func aesEncrypt(key: KeyNum,
                                initializationVector: IVectorEnum,
                                options: Int = kCCOptionPKCS7Padding) -> String? {
        
        if let keyData = key.value.data(using: String.Encoding.utf8),
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
                                      initializationVector.value,
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
    
    fileprivate func aesDecrypt(key: KeyNum,
                                initializationVector: IVectorEnum,
                                options: Int = kCCOptionPKCS7Padding) -> String? {
        
        if let keyData = key.value.data(using: .utf8),
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
                                      initializationVector.value,
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

