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
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black){
        
        AppManager.shared.getLanguageTypes { languageType in
            switch languageType{
            case .khmer:
                self.font = UIFont(name: FontNameManager.NotoSansKhmer_Regular  , size: size)
            case .english:
                self.font = UIFont(name: FontNameManager.Roboto_Regular  , size: size)
            }
        }
        self.textColor = color
        
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor = .black ){
        
        AppManager.shared.getLanguageTypes { languageType in
            switch languageType{
            case .khmer:
                self.font =  UIFont(name: FontNameManager.NotoSansKhmer_Medium  , size: size)
            case .english:
                self.font =  UIFont(name: FontNameManager.Roboto_Medium  , size: size)
            }
        }
        self.textColor = color
    }
    
    func fontBold(_ size: CGFloat, color: UIColor = .black){
        
        AppManager.shared.getLanguageTypes { languageType in
            switch languageType{
            case .khmer:
                self.font =  UIFont(name: FontNameManager.NotoSansKhmer_Bold  , size: size)
            case .english:
                self.font =  UIFont(name: FontNameManager.Roboto_Bold  , size: size)
            }
        }
        self.textColor = color
    }
    
}


extension UITextField{
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black){
        
        AppManager.shared.getLanguageTypes { languageType in
            switch languageType{
            case .khmer:
                self.font =  UIFont(name: FontNameManager.NotoSansKhmer_Regular  , size: size)
            case .english:
                self.font =  UIFont(name: FontNameManager.Roboto_Regular  , size: size)
            }
        }
        self.textColor = color
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor = .black ){
        
        AppManager.shared.getLanguageTypes { languageType in
            switch languageType{
            case .khmer:
                self.font =  UIFont(name: FontNameManager.NotoSansKhmer_Medium  , size: size)
            case .english:
                self.font =  UIFont(name: FontNameManager.Roboto_Medium  , size: size)
            }
        }
        self.textColor = color
    }
    
    func fontBold(_ size: CGFloat, color: UIColor = .black){
        
        AppManager.shared.getLanguageTypes { languageType in
            switch languageType{
            case .khmer:
                self.font =  UIFont(name: FontNameManager.NotoSansKhmer_Bold  , size: size)
            case .english:
                self.font =  UIFont(name: FontNameManager.Roboto_Bold  , size: size)
            }
        }
        self.textColor = color
    }
}
