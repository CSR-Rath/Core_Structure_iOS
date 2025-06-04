//
//  UIFont.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import UIKit

// MARK: - For font size label
extension UITextField{
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black){
        
        LanguageManager.shared.getLanguageTypes { languageType in
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
        
        LanguageManager.shared.getLanguageTypes { languageType in
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
        
        LanguageManager.shared.getLanguageTypes { languageType in
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
