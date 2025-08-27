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

extension UIFont {

    static func appFont(style: FontStyle, size: CGFloat) -> UIFont {
        
        let lang = LanguageManager.shared.getCurrentLanguage()
        let fontName: String?
        
        switch (lang, style) { //Check language and font style
            
            // MARK: - For Khmer
        case (.khmer, .light): fontName = FontName.FontKhmer.light
        case (.khmer, .regular): fontName = FontName.FontKhmer.regular
        case (.khmer, .medium): fontName = FontName.FontKhmer.medium
        case (.khmer, .semibold): fontName = FontName.FontKhmer.semibold
        case (.khmer, .bold): fontName = FontName.FontKhmer.bold
            
            // MARK: - For English
        case (.english, .light): fontName = FontName.FontEnglish.light
        case (.english, .regular): fontName = FontName.FontEnglish.regular
        case (.english, .medium): fontName = FontName.FontEnglish.medium
        case (.english, .semibold): fontName = FontName.FontEnglish.semibold
        case (.english, .bold): fontName = FontName.FontEnglish.bold
        case (.english, .italic): fontName = FontName.FontEnglish.italic
            
            // MARK: - For Chinese
        case (.chinese, .light): fontName = FontName.FontChinese.light
        case (.chinese, .regular): fontName = FontName.FontChinese.regular
        case (.chinese, .medium): fontName = FontName.FontChinese.medium
        case (.chinese, .semibold): fontName = FontName.FontChinese.semibold
        case (.chinese, .bold): fontName = FontName.FontChinese.bold
            
        default: fontName = nil
        }
        
        guard let fontName =  UIFont(name: fontName ?? "", size: size) else {
            
            print("Font name not found.")
            
            return UIFont.systemFont(ofSize: size)
        }
        

        return fontName
    }
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
    
    func fontLight(_ size: CGFloat, color: UIColor = .black){
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
    
    func fontLight(_ size: CGFloat,  color: UIColor ){
        self.font = UIFont.appFont(style: .light, size: size)
        self.textColor = color
    }
    
    func fontRegular(_ size: CGFloat, color: UIColor ){
        self.font = UIFont.appFont(style: .regular, size: size)
        self.textColor = color
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor ){
        self.font = UIFont.appFont(style: .medium, size: size)
        self.textColor = color
    }
    
    func fontSemibold(_ size: CGFloat, color: UIColor){
        self.font = UIFont.appFont(style: .semibold, size: size)
        self.textColor = color
    }
    
    func fontBold(_ size: CGFloat,  color: UIColor ){
        self.font = UIFont.appFont(style: .bold, size: size)
        self.textColor = color
    }
    
    func fontItalic(_ size: CGFloat,  color: UIColor ){
        self.font = UIFont.appFont(style: .italic, size: size)
        self.textColor = color
    }
}

extension UIButton {
    
    func fontLight(_ size: CGFloat,  color: UIColor){
        self.titleLabel?.font = UIFont.appFont(style: .light, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontRegular(_ size: CGFloat, color: UIColor){
        self.titleLabel?.font = UIFont.appFont(style: .regular, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontMedium(_ size: CGFloat, color: UIColor){
        self.titleLabel?.font = UIFont.appFont(style: .medium, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontSemibold(_ size: CGFloat, color: UIColor){
        self.titleLabel?.font = UIFont.appFont(style: .semibold, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontBold(_ size: CGFloat, color: UIColor){
        self.titleLabel?.font = UIFont.appFont(style: .bold, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontItalic(_ size: CGFloat,  color: UIColor){
        self.titleLabel?.font = UIFont.appFont(style: .italic, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
}






