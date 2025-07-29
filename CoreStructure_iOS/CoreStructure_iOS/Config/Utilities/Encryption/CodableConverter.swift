//
//  CodableConverter.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/6/25.
//

import Foundation

class CodableConverter{
    
    static let shared = CodableConverter()
    
    func codableToJSONString<T: Codable>(_ object: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: for better readability
        do {
            let data = try encoder.encode(object)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to encode object: \(error)")
            return nil
        }
    }
    
    
    func encodeToJSONData<T: Encodable>(_ object: T, prettyPrinted: Bool = false) -> Data? {
        let encoder = JSONEncoder()
        if prettyPrinted {
            encoder.outputFormatting = .prettyPrinted
        }
        
        do {
            let data = try encoder.encode(object)
            return data
        } catch {
            print("Encoding failed: \(error)")
            return nil
        }
    }
}


extension Encodable {
    public func toJsonObj() -> String{
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(self)
        return String(data: jsonData, encoding: .utf8) ?? ""
    }
    
    public func toData() -> Data {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(self)
        return jsonData
    }
}
