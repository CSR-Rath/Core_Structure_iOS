//
//  ConditionUIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import Foundation
import UIKit


extension UIView{
    
    func isHasSafeAreaInsets() -> Bool {
        return self.safeAreaInsets.top > 0
    }
    
}
