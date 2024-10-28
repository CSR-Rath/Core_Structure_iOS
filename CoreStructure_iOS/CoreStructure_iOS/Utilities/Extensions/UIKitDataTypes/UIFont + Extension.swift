//
//  UIFont.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import Foundation
import UIKit

extension UILabel{
    
    func getHeightForLabel() -> CGFloat {
        let labelWidth = self.frame.width
        let maxSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = self.sizeThatFits(maxSize)
        return requiredSize.height
    }

    func fontRegular(_ size: CGFloat){
//        self.font =  UIFont(name: "name_font" , size: size ) real
        
        self.font = UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    func fontMedium(_ size: CGFloat ){


        self.font = UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    func fontBold(_ size: CGFloat){
        self.font = UIFont.systemFont(ofSize: size, weight: .bold)
    }
    

    func fontSemiBold(_ size: CGFloat ){
        self.font = UIFont.systemFont(ofSize: size, weight: .semibold)
    }

}
