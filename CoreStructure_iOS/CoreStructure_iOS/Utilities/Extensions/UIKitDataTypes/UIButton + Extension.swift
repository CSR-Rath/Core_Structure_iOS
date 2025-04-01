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
    
    func spacingButton(top: CGFloat = 0,
                       left: CGFloat = 0,
                       bottom: CGFloat = 0,
                       right: CGFloat = 0){
        
        self.contentEdgeInsets = UIEdgeInsets(top: top,
                                              left: left,
                                              bottom: bottom,
                                              right: right)
    }
    
    
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
    
}



