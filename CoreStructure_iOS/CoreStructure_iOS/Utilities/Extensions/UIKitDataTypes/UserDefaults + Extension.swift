//
//  UserDefaults + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/10/24.
//

import Foundation

extension UserDefaults{

    //MARK: get object
    public func getObject<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    //MARK: Save object
    public func saveObject<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}


