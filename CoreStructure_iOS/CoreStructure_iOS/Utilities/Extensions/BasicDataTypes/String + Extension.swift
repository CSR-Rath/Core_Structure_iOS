//
//  String.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation
import UIKit


//MARK: ==================== Handle localize ====================

func setLanguage(langCode: LanguageEnum) {
    UserDefaults.standard.setValue(langCode.rawValue, forKey: KeyUser.language)
}

extension String {
    
    func getLangauge()->String{
        return UserDefaults.standard.string(forKey: KeyUser.language) ?? "en"
    }
    
    func localizeString() -> String {
        let lang = UserDefaults.standard.string(forKey: KeyUser.language)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}

//MARK: ==================== End handle localize ====================




//MARK: ==================== Handle webview ====================

//lazy var descriptionLbl: UITextView = {
//    let textView = UITextView()
//    textView.translatesAutoresizingMaskIntoConstraints = false
//    textView.textColor = .white
//    textView.backgroundColor = .clear//.mainColor
//    textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
//    textView.attributedText = "".htmlToAttributedString
//    textView.isEditable = false
//    textView.showsVerticalScrollIndicator = false
//    textView.isScrollEnabled = false
//    return textView
//}()

extension String{ // HTML to string
    
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        var attribStr = NSMutableAttributedString()
        do {
            
            attribStr = try NSMutableAttributedString(data: data,
                                                      options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding:String.Encoding.utf8.rawValue],
                                                      documentAttributes: nil)
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            
            let textRangeForFont : NSRange = NSMakeRange(0, attribStr.length)
            attribStr.addAttributes([ 
                NSAttributedString.Key.foregroundColor:UIColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font:font], range: textRangeForFont)
            
        } catch {
            return NSAttributedString()
        }
        
        return attribStr
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

//MARK: ==================== End handle webview ====================

enum DateFormat: String {
    
    case time = "h:mm a"  /// Time format (e.g., 5:30 PM)
   
    case short = "dd-MM-yyyy"  /// Short date format (e.g., 31/12/2023)
    case shortSlash = "dd/MM/yyyy"  /// Short date format (e.g., 31/12/2023)
 
    case medium = "dd-MMMM-yyyy"   /// Medium date format (e.g., 31-December-2023)
    case mediumSlash = "dd/MMMM/yyyy"   /// Medium date format (e.g., 31-December-2023)

    case long = "EEEE, dd MMMM yyyy"  /// Long date format (e.g., Sunday, 31 December 2023)
    case full = "EEEE, dd MMMM yyyy h:mm a"  /// Full date and time format (e.g., Sunday, 31 December 2023 5:30 PM)
}


//Localizable
extension String{
    static let  confirmlLocalizable  = "confirm".localizeString()
    
}


