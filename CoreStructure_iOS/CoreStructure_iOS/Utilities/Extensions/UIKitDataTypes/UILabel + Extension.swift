//
//  UILabel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit

extension UILabel {
    ///  working when width of label width < width of content text
    func autoScaling(to scale: CGFloat = 0.8) {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = scale
        self.numberOfLines = 1
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
    
    
    func labelHeightForWidth() -> CGFloat {
        let labelWidth = self.frame.width
        let maxSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = self.sizeThatFits(maxSize)
        return requiredSize.height
    }
    
    func setAttributedText(parts: [(text: String,
                                    font: UIFont,
                                    color: UIColor)]) {
        let attributedString = NSMutableAttributedString()
        
        for part in parts {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: part.font,
                .foregroundColor: part.color
            ]
            let attributedPart = NSAttributedString(string: part.text, attributes: attributes)
            attributedString.append(attributedPart)
        }
        
        self.attributedText = attributedString
    }
}


