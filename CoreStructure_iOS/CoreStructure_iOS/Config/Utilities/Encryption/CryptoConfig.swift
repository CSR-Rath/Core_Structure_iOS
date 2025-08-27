//
//  CryptoConfig.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/6/25.
//

import Foundation

struct CryptoConfig {
    
    struct Payment {
        static let key = AppConfiguration.shared.paymentKey       // 32 chars
        static let iv  = AppConfiguration.shared.paymentVector    // 16 chars
    }

    struct Auth {
        static let key = AppConfiguration.shared.paymentKey
        static let iv  = AppConfiguration.shared.paymentVector
    }

    struct Transfer {
        static let key = AppConfiguration.shared.paymentKey
        static let iv  = AppConfiguration.shared.paymentVector
    }

    struct Reservation {
        static let key = AppConfiguration.shared.paymentKey
        static let iv  = AppConfiguration.shared.paymentVector
    }
    
}
