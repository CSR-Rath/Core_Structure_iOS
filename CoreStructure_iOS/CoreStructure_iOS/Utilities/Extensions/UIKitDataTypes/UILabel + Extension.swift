//
//  UILabel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import Foundation
import UIKit


extension UILabel {
    
    func resizeLabelToFitContent() { // auto with label in the Stack or fit label
        // Set horizontal hugging and compression resistance priorities to required
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        // Resize the label to fit its content
        self.sizeToFit()
    }
    
}
