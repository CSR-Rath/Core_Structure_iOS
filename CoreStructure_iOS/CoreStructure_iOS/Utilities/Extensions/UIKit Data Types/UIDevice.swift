//
//  UIDevice.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/8/24.
//

import Foundation
import UIKit

extension UIDevice {
    
    func iPhone()->Bool{
        if UIDevice.current.userInterfaceIdiom == .phone{
            return true
        }else{
            return false
        }
    }
    
    func iPaid()->Bool{
        if UIDevice.current.userInterfaceIdiom == .pad{
            return true
        }else{
            return false
        }
    }
    
    

}

