//
//  SetupLanguage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 7/11/24.
//

import Foundation

func setLanguage(langCode: String) {
    UserDefaults.standard.setValue(langCode, forKey: AppConstants.language)
}

extension String {
    func localizeString() -> String {
        let lang = UserDefaults.standard.string(forKey: AppConstants.language)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
