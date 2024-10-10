//
//  UILabel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import Foundation
import UIKit


extension UILabel{
    func autoWidthInstack(){
        //Set auto width in stack
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.sizeToFit()
    }
}
