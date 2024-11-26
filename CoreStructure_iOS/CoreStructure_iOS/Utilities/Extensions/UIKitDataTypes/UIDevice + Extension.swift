//
//  UIDevice.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/8/24.
//

import Foundation
import UIKit

extension UIDevice {
    
    static func isLandscape() -> Bool{
            if UIDevice.current.orientation.isLandscape {
                return true
            }else{
                return false
            }
        }
    
    static func iPhone()->Bool{
        if UIDevice.current.userInterfaceIdiom == .phone{
            return true
        }else{
            return false
        }
    }
    
    static func iPaid()->Bool{
        if UIDevice.current.userInterfaceIdiom == .pad{
            return true
        }else{
            return false
        }
    }
    
}



