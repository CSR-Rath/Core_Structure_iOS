//
//  AESUtils.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import Foundation
import CommonCrypto
import CryptoKit

let passcode = "123456"
let encryption = AESUtils.shared.encryptionAES(value: "\(passcode)",
                                                 key256 : "" , iv: "")
//Advanced Encryption Standard
class AESUtils:NSObject {
    
    static let shared = AESUtils()
    
    func encryptionAES(value: String,key256: String,iv: String) -> String {
        let result = value.aesEncrypt(key: key256, iv: iv)
        return result ?? ""
    }
    
    func decryptionAES(value: String,key256: String,iv: String) -> String {
        let result = value.aesDecrypt(key: key256, iv: iv)
        return result ?? ""
    }
    
    let generateTradeNOKNumber = 15
    
    func generateTradeNO() -> String? {
        
        let sourceStr = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var resultStr = ""

        for _ in 0..<self.generateTradeNOKNumber {
            let index = UInt(Int(arc4random()) % sourceStr.count)
            let oneStr = (sourceStr as NSString).substring(with: NSRange(location: Int(index), length: 1))
            resultStr += oneStr
        }
        return resultStr
    }
}

extension String {
    
    func aesEncrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = self.data(using: String.Encoding.utf8),
           let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
            
            
            let keyLength              = size_t(kCCKeySizeAES256)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
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
    
    func aesDecrypt(key: String, iv: String, options: Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: .utf8),
           let data = Data(base64Encoded: self),
           let cryptData = NSMutableData(length: Int(data.count) + kCCBlockSizeAES128) {
            
            let keyLength = size_t(kCCKeySizeAES256)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesDecrypted: size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
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
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
    
}



