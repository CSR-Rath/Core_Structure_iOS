//
//  AppConfiguration.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/11/24.
//

import Foundation
//Referent ==> https://medium.com/@tejaswini-27k/ios-project-different-environments-xcode-configurations-and-scheme-752ee4404bfa
class AppConfiguration {
    
    static let shared = AppConfiguration()
    
    lazy var versionApp: String = {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("versionApp must not be empty in plist")
        }
        return version
    }()
    
    lazy var versionBuildApp: String = {
        guard let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("versionBuildApp must not be empty in plist")
        }
        return build
    }()
    
    lazy var apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return key
    }()
    
    lazy var apiBaseURL: String = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return baseURL
    }()
    
//    lazy var imagesBaseURL: String = {
//        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
//            fatalError("ImageBaseURL must not be empty in plist")
//        }
//        return imageBaseURL
//    }()
    
    lazy var bundleID: String = {
        guard let id = Bundle.main.object(forInfoDictionaryKey: "BUNDLE_ID") as? String else {
            fatalError("Bundle ID must not be empty in plist")
        }
        return id
    }()
    
    
    lazy var paymentKey : String = {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "PAYMENT_KEY") as? String else {
            fatalError("versionApp must not be empty in plist")
        }
        return version
    }()
    
    lazy var paymentVector : String = {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "PAYMENT_VECTOR") as? String else {
            fatalError("versionApp must not be empty in plist")
        }
        return version
    }()
    
}


func printAppConfiguration(){
    print(AppConfiguration.shared.versionApp)
    print(AppConfiguration.shared.versionApp)
    print(AppConfiguration.shared.versionBuildApp)
    print(AppConfiguration.shared.apiBaseURL)
    print(AppConfiguration.shared.apiKey)
    print(AppConfiguration.shared.paymentKey)
    print(AppConfiguration.shared.paymentVector)
}
