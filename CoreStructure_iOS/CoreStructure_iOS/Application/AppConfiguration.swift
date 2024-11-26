//
//  AppConfiguration.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/11/24.
//

import Foundation
//MARK: - Get from info
 class AppConfiguration {
     
     static let shared = AppConfiguration()
     
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
     
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
     
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
     
     
     // bundleID or bundle identifier
     lazy var bundleID: String = {
         guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "BUNDLE_ID") as? String else {
             fatalError("ApiBaseURL must not be empty in plist")
         }
         return apiBaseURL
     }()
}
