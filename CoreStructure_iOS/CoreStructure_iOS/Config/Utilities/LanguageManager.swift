//
//  LanguageManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 17/6/25.
//

import Foundation

enum LanguageTypeEnum: String {
    case khmer = "km"
    case english = "en"
    case chinese = "zh"
}

class LanguageManager {
    
    static let shared = LanguageManager()
    private init() {}
    
    private let langualeKey = "langualeKey"

    func setCurrentLanguage(_ lang: LanguageTypeEnum) {
        print("===> lang: \(lang.rawValue)")
        UserDefaults.standard.setValue(lang.rawValue, forKey: langualeKey)
    }
    
    func getCurrentLanguage() -> LanguageTypeEnum {
        let rawValue = UserDefaults.standard.string(forKey: langualeKey) ?? LanguageTypeEnum.english.rawValue
        print("===> getCurrentLanguage: \(rawValue)")
        return LanguageTypeEnum(rawValue: rawValue) ?? .english
    }
}
