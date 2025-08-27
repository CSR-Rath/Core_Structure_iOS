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
    
    private let languageKey = "languageKey"

    func setCurrentLanguage(_ lang: LanguageTypeEnum) {
//        print("🌐 Setting language to: \(lang.rawValue)")
        UserDefaults.standard.setValue(lang.rawValue, forKey: languageKey)
    }
    
    func getCurrentLanguage() -> LanguageTypeEnum {
        let rawValue = UserDefaults.standard.string(forKey: languageKey) ?? LanguageTypeEnum.english.rawValue
        return LanguageTypeEnum(rawValue: rawValue) ?? .english
    }
}
