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

    func fontT(_ size: CGFloat ){

//        if  Localize.currentLanguage() == "en"{
//            self.font = UIFont(name: Environment.English_MEDIUM , size: size)//"SF-Pro-Text-Medium"
//        }else{
//            self.font = UIFont(name: Environment.KHMER_MEDIUM , size: size)
//        }
    }
    
    func fontMedium(_ size: CGFloat ){

//        if  Localize.currentLanguage() == "en"{
//            self.font = UIFont(name: Environment.English_MEDIUM , size: size)//"SF-Pro-Text-Medium"
//        }else{
//            self.font = UIFont(name: Environment.KHMER_MEDIUM , size: size)
//        }
    }
    
    func fontBold(_ size: CGFloat){
        
        self.font = UIFont.systemFont(ofSize: size, weight: .bold)
        
//        if  Localize.currentLanguage() == "en"{
//            self.font = UIFont(name: Environment.English_BOLD  , size: size)
//        }else{
//            self.font = UIFont(name: Environment.KHMER_BOLD  , size: size)
//        }
    }
    
    func fontRegular(_ size: CGFloat){
        self.font = UIFont.systemFont(ofSize: size, weight: .regular)
        
        
        //        self.textColor = .white
//        if  Localize.currentLanguage() == "en"{
//            self.font = UIFont(name: Environment.English_REGUAR  , size: size) // English_Font
//        }else{                                                                    // Chiness_Font
//            self.font = UIFont(name: Environment.KHMER_REGULAR  , size: size) // Khmer_Font
//        }
    }
    
    func fontSemiBold(_ size: CGFloat ){
        //        self.textColor = .white
//        if  Localize.currentLanguage() == "en"{
//            self.font = UIFont(name: Environment.English_MEDIUM  , size: size)
//        }else{
//            self.font = UIFont(name: Environment.KHMER_MEDIUM  , size: size)
//        }
    }
    
    func fontBoldItalic(_ size: CGFloat){
        
//        if  Localize.currentLanguage() == "en"{
//            self.font = UIFont(name: Environment.English_BOLD_Italic  , size: size)
//        }else{
//            self.font = UIFont(name: Environment.KHMER_BOLD  , size: size)
//        }
    }
    
    func fontNunitosansReguar(_ size: CGFloat){
        //        self.textColor = .white
//        if  Localize.currentLanguage() == "en"{
//            self.font = UIFont(name: Environment.Nunitosans_REGUAR  , size: size) // English_Font
//        }else{                                                                    // Chiness_Font
//            self.font = UIFont(name: Environment.Nunitosans_REGUAR  , size: size) // Khmer_Font
//        }
    }
    
    func fontNunitosansBold(_ size: CGFloat){
        //        self.textColor = .white
//        if  Localize.currentLanguage() == "en"{
//            self.font = UIFont(name: Environment.Nunitosans_MEDIUM  , size: size) // English_Font
//        }else{                                                                    // Chiness_Font
//            self.font = UIFont(name: Environment.Nunitosans_MEDIUM  , size: size) // Khmer_Font
//        }
    }

}
