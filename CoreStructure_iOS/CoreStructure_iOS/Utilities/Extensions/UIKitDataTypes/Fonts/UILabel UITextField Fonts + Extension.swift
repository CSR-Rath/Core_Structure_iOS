//
//  UIFont.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import Foundation
import UIKit

extension UILabel{
    
    func labelHeightForWidth() -> CGFloat {
        let labelWidth = self.frame.width
        let maxSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = self.sizeThatFits(maxSize)
        return requiredSize.height
    }

    func fontRegular(_ size: CGFloat, color: UIColor = .white){
        self.font = UIFont.systemFont(ofSize: size, weight: .regular)
        self.textColor = color
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor = .white ){
        self.font = UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    func fontBold(_ size: CGFloat, color: UIColor = .white){
        self.font = UIFont.systemFont(ofSize: size, weight: .bold)
    }

    func fontSemiBold(_ size: CGFloat, color: UIColor = .white ){
        self.font = UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}


extension UITextField{
    
    func fontRegular(_ size: CGFloat, color: UIColor = .white){
        self.font = UIFont.systemFont(ofSize: size, weight: .regular)
        self.textColor = color
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor = .white ){
        self.font = UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    func fontBold(_ size: CGFloat, color: UIColor = .white){
        self.font = UIFont.systemFont(ofSize: size, weight: .bold)
    }

    func fontSemiBold(_ size: CGFloat, color: UIColor = .white ){
        self.font = UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}





