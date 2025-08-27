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

    // MARK: - Info.plist Keys
    private enum InfoPlistKey: String {
        case version = "CFBundleShortVersionString"
        case build = "CFBundleVersion"
        case bundleID = "BUNDLE_ID"
        case apiKey = "API_KEY"
        case baseURL = "BASE_URL"
        case paymentKey = "PAYMENT_KEY"
        case paymentVector = "PAYMENT_VECTOR"
    }

    // MARK: - App Info

    let versionApp: String = AppConfiguration.getValue(for: .version)
    let versionBuildApp: String = AppConfiguration.getValue(for: .build)
    let bundleID: String = AppConfiguration.getValue(for: .bundleID)

    // MARK: - API Configuration

    let apiKey: String = AppConfiguration.getValue(for: .apiKey)
    let apiBaseURL: String = AppConfiguration.getValue(for: .baseURL)

    // MARK: - Encryption Keys (AES-256, IV)

    let paymentKey: String = AppConfiguration.getValue(for: .paymentKey)
    let paymentVector: String = AppConfiguration.getValue(for: .paymentVector)

    // MARK: - Private Helper

    private static func getValue(for key: InfoPlistKey) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String,
              !value.isEmpty else {
            fatalError("❌ [AppConfiguration] Missing or empty '\(key.rawValue)' in Info.plist")
        }
        return value
    }
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
