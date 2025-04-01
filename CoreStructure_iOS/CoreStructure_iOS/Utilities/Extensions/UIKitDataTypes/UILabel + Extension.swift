//
//  UILabel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit

extension UILabel {
    
    /// Automatically scales the font size when the label's text exceeds the available width.
    func enableAutoScaling(to scale: CGFloat = 0.8) {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = scale
        self.numberOfLines = 0
    }
    
    /// Adjusts the label's size dynamically when used inside a `UIStackView` or to fit content.
    func adjustSizeToFitContent() {
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.sizeToFit()
    }
    
    /// Calculates and returns the label’s width after fitting its content.
    func getFittedWidth() -> CGFloat {
        self.sizeToFit()
        return self.frame.width
    }
    
}



