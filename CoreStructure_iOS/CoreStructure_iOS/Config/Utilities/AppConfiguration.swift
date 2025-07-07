//
//  AppConfiguration.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/11/24.
//

import Foundation
//MARK: - Referent ==> https://medium.com/@tejaswini-27k/ios-project-different-environments-xcode-configurations-and-scheme-752ee4404bfa

final class AppConfiguration {
    
    static let shared = AppConfiguration()
    
    private init() {}

    // MARK: - App Info

    lazy var versionApp: String = {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("❌ [AppConfiguration] Missing 'CFBundleShortVersionString' in Info.plist")
        }
        return version
    }()
    
    lazy var versionBuildApp: String = {
        guard let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("❌ [AppConfiguration] Missing 'CFBundleVersion' in Info.plist")
        }
        return build
    }()
    
    lazy var bundleID: String = {
        guard let id = Bundle.main.object(forInfoDictionaryKey: "BUNDLE_ID") as? String else {
            fatalError("❌ [AppConfiguration] Missing 'BUNDLE_ID' in Info.plist")
        }
        return id
    }()
    
    // MARK: - API Configuration

    lazy var apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("❌ [AppConfiguration] Missing 'API_KEY' in Info.plist")
        }
        return key
    }()
    
    lazy var apiBaseURL: String = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("❌ [AppConfiguration] Missing 'BASE_URL' in Info.plist")
        }
        return baseURL
    }()

    // MARK: - Encryption Keys (AES-256, IV)

    lazy var paymentKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "PAYMENT_KEY") as? String else {
            fatalError("❌ [AppConfiguration] Missing 'PAYMENT_KEY' in Info.plist")
        }
        return key
    }()
    
    lazy var paymentVector: String = {
        guard let vector = Bundle.main.object(forInfoDictionaryKey: "PAYMENT_VECTOR") as? String else {
            fatalError("❌ [AppConfiguration] Missing 'PAYMENT_VECTOR' in Info.plist")
        }
        return vector
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
