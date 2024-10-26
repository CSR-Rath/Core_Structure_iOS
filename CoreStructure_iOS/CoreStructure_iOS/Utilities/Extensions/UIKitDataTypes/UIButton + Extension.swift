//
//  UIButton + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/10/24.
//

import Foundation
import UIKit

extension UIButton{
    
    func addTargetButton(target: Any, action: Selector){
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
}



