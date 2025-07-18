//
//  SSPaddingLabel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 8/11/24.
//

import Foundation
import UIKit

class BaseUILabelPadding: UILabel {
    var padding : UIEdgeInsets
    
    // Create a new SSPaddingLabel instance programamtically with the desired insets
    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }
    
    // Create a new SSPaddingLabel instance programamtically with default insets
    override init(frame: CGRect) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(frame: frame)
    }
    
    // Create a new SSPaddingLabel instance from Storyboard with default insets
    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(coder: aDecoder)
    }
    

    override func drawText(in rect: CGRect) {
          let paddedRect = rect.inset(by: padding)
          super.drawText(in: paddedRect)
      }
    
    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    // Override `sizeThatFits(_:)` method for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}

//private let label: SSPaddingLabel = {
//    let label = SSPaddingLabel()
//    label.font = UIFont.appFont(style: .bold, size: 14)
//    label.textColor = .black
//    label.backgroundColor = .white
//    label.text = "Title"
//    label.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
//    label.translatesAutoresizingMaskIntoConstraints = false
//    return label
//}()
