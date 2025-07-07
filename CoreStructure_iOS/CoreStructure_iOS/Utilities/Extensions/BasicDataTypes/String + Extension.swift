//
//  String.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit
import CoreImage

enum CodeType {
    case qrCode
    case barCode128
}

extension String {
    // localizeString
    func localizeString() -> String {
        let lang = LanguageManager.shared.getCurrentLanguage().rawValue
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}


extension String {
    
    func toCodeImage(type: CodeType) -> UIImage? {
        // QRCode or Bar Code
        
        let data: Data?
        let filterName: String
        
        switch type {
        case .qrCode:
            data = self.data(using: .utf8)
            filterName = "CIQRCodeGenerator"
            
        case .barCode128:
            data = self.data(using: .ascii)
            filterName = "CICode128BarcodeGenerator"
        }
        
        guard let inputData = data else { return nil }
        
        guard let filter = CIFilter(name: filterName) else { return nil }
        filter.setValue(inputData, forKey: "inputMessage")
        
        let scale: CGFloat = 8 // >= 15 recommment
        
        // For QR code, add color filter to make background clear and foreground black
        if type == .qrCode, let colorFilter = CIFilter(name: "CIFalseColor") {
            colorFilter.setValue(filter.outputImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(color: UIColor.clear), forKey: "inputColor1") // Background clear
            colorFilter.setValue(CIColor(color: UIColor.black), forKey: "inputColor0") // Foreground black
            
            if let output = colorFilter.outputImage?.transformed(by: CGAffineTransform(scaleX: scale, y: scale)) {
                return UIImage(ciImage: output)
            }
        } else if let outputImage = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: scale, y: scale)) {
            // For barcode, just scale and return
            return UIImage(ciImage: outputImage)
        }
        
        return nil
    }
}

