//
//  UIFont + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/6/25.
//

import UIKit

enum FontStyle {
    case light
    case regular
    case medium
    case semibold
    case bold
    case italic
}

extension UILabel {
    
    func fontLight(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .light, size: size)
        self.textColor = color
    }
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .regular, size: size)
        self.textColor = color
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .medium, size: size)
        self.textColor = color
    }
    
    func fontSemibold(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .semibold, size: size)
        self.textColor = color
    }
    
    func fontBold(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .bold, size: size)
        self.textColor = color
    }
    
    func fontItalic(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .italic, size: size)
        self.textColor = color
    }
    
}

extension UITextField {
    
    func fontLight(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .light, size: size)
        self.textColor = color
    }
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .regular, size: size)
        self.textColor = color
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .medium, size: size)
        self.textColor = color
    }
    
    func fontSemibold(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .semibold, size: size)
        self.textColor = color
    }
    
    func fontBold(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .bold, size: size)
        self.textColor = color
    }
    
    func fontItalic(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .italic, size: size)
        self.textColor = color
    }
}

extension UITextView {
    
    func fontLight(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .light, size: size)
        self.textColor = color
    }
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .regular, size: size)
        self.textColor = color
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .medium, size: size)
        self.textColor = color
    }
    
    func fontSemibold(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .semibold, size: size)
        self.textColor = color
    }
    
    func fontBold(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .bold, size: size)
        self.textColor = color
    }
    
    func fontItalic(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .italic, size: size)
        self.textColor = color
    }
}

extension UIButton {
    
    func fontLight(_ size: CGFloat,  color: UIColor = .black){
        self.titleLabel?.font = UIFont.appFont(style: .light, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black ){
        self.titleLabel?.font = UIFont.appFont(style: .regular, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor = .black){
        self.titleLabel?.font = UIFont.appFont(style: .medium, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontSemibold(_ size: CGFloat, color: UIColor = .black){
        self.titleLabel?.font = UIFont.appFont(style: .semibold, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontBold(_ size: CGFloat, color: UIColor = .black){
        self.titleLabel?.font = UIFont.appFont(style: .bold, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontItalic(_ size: CGFloat,  color: UIColor = .black){
        self.titleLabel?.font = UIFont.appFont(style: .italic, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
}

extension UIFont {

    static func appFont(style: FontStyle, size: CGFloat) -> UIFont {
        
        let lang = LanguageManager.shared.getCurrentLanguage()
        let fontName: String?
        
        switch (lang, style) { //Check language and font style
            
            // MARK: - For Khmer
        case (.khmer, .light): fontName = FontNameEnum.KhmerEnum.light
        case (.khmer, .regular): fontName = FontNameEnum.KhmerEnum.regular
        case (.khmer, .medium): fontName = FontNameEnum.KhmerEnum.medium
        case (.khmer, .semibold): fontName = FontNameEnum.KhmerEnum.semibold
        case (.khmer, .bold): fontName = FontNameEnum.KhmerEnum.bold
            
            // MARK: - For English
        case (.english, .light): fontName = FontNameEnum.EnglishEnum.light
        case (.english, .regular): fontName = FontNameEnum.EnglishEnum.regular
        case (.english, .medium): fontName = FontNameEnum.EnglishEnum.medium
        case (.english, .semibold): fontName = FontNameEnum.EnglishEnum.semibold
        case (.english, .bold): fontName = FontNameEnum.EnglishEnum.bold
        case (.english, .italic): fontName = FontNameEnum.EnglishEnum.italic
            
            // MARK: - For Chinese
        case (.chinese, .light): fontName = FontNameEnum.ChineseEnum.light
        case (.chinese, .regular): fontName = FontNameEnum.ChineseEnum.regular
        case (.chinese, .medium): fontName = FontNameEnum.ChineseEnum.medium
        case (.chinese, .semibold): fontName = FontNameEnum.ChineseEnum.semibold
        case (.chinese, .bold): fontName = FontNameEnum.ChineseEnum.bold
            
        default: fontName = nil
        }
        
        guard let fontName =  UIFont(name: fontName ?? "", size: size) else {
            
            print("Font name not found.")
            
            return UIFont.systemFont(ofSize: size)
        }
        

        return fontName
    }
}




