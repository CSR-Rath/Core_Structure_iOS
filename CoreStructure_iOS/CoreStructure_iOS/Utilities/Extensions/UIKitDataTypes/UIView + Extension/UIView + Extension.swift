//
//  UIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit

extension UIView{
    
    enum RoundCornersAt{
       case topRight
       case topLeft
       case bottomRight
       case bottomLeft
   }
    
    func addSubviews(of views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func roundCorners(corners:[RoundCornersAt], radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [
            corners.contains(.topRight) ? .layerMaxXMinYCorner:.init(),
            corners.contains(.topLeft) ? .layerMinXMinYCorner:.init(),
            corners.contains(.bottomRight) ? .layerMaxXMaxYCorner:.init(),
            corners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init(),
        ]
    }
    
    func fitSize(){
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
//    func makeSecure() { // prevent view
//        let field = UITextField()
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.self.width, height: field.frame.self.height))
//        field.isSecureTextEntry = true
//        self.addSubview(field)
//        field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.layer.superlayer?.addSublayer(field.layer)
//        field.layer.sublayers?.last?.addSublayer(self.layer)
//        field.leftView = view
//        field.leftViewMode = .always
//    }
}
