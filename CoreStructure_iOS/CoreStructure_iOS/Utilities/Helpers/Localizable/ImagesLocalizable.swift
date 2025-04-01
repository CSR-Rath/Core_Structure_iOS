//
//  ImagesLocalizable.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/3/25.
//

import Foundation
import UIKit

class ImagesLocalizable{
    
   static func imageLogout() -> UIImage{
        
        let currentLanguage: LanguageTypeEnum = LanguageTypeEnum(rawValue: getLanguageType()) ?? .KHMER
        var image: UIImage
        switch currentLanguage {
        case .KHMER:
            image = .ic400
        case .ENGLISH:
            image = .ic400
        case .NONE:
            image = .ic400
        }
        return image
    }
}
