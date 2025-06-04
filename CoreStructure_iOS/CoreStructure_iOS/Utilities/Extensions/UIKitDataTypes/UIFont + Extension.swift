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
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .regular, size: size)
        self.textColor = color
    }
    
    func fontBold(_ size: CGFloat,  color: UIColor = .black){
        self.font = UIFont.appFont(style: .bold, size: size)
        self.textColor = color
    }

    func setFont(style: FontStyle, size: CGFloat) {
        self.font = UIFont.appFont(style: style, size: size)

    }
    
}

extension UIButton {
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black ){
        self.titleLabel?.font = UIFont.appFont(style: .regular, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func fontBold(_ size: CGFloat, color: UIColor = .black){
        self.titleLabel?.font = UIFont.appFont(style: .bold, size: size)
        self.setTitleColor(color, for: .normal)
    }
    
    func setFont(style: FontStyle, size: CGFloat) {
        self.titleLabel?.font = UIFont.appFont(style: style, size: size)
    }
}

extension UITextField {
    
    func fontRegular(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .regular, size: size)
        self.textColor = color
    }
    
    func fontBold(_ size: CGFloat, color: UIColor = .black){
        self.font = UIFont.appFont(style: .bold, size: size)
        self.textColor = color
    }
    
    func setFont(style: FontStyle, size: CGFloat) {
        self.font = UIFont.appFont(style: style, size: size)
    }
    
}

extension UITextView {
    
    func fontRegular(_ size: CGFloat){
        self.font = UIFont.appFont(style: .regular, size: size)
    }
    
    func fontBold(_ size: CGFloat){
        self.font = UIFont.appFont(style: .bold, size: size)
    }
    
    func setFont(style: FontStyle, size: CGFloat) {
        self.font = UIFont.appFont(style: style, size: size)
    }
}

extension UIFont {

    static func appFont(style: FontStyle, size: CGFloat) -> UIFont {
        
        let lang = LanguageManager.shared.getCurrentLanguage()
        let fontName: String?

        switch (lang, style) {
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

        return UIFont(name: fontName ?? "", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}




