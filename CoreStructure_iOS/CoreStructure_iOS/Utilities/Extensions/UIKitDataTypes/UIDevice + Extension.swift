//
//  UIDevice.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/8/24.
//

import Foundation
import UIKit

import UIKit

extension UIDevice {
    
    static func isLandscape() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    static func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}


