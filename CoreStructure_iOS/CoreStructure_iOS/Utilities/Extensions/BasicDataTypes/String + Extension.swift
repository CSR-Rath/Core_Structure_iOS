//
//  String.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation
import UIKit



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



//Localizable
//extension String{
//   
//    static let  confirmlLocalizable  = "confirm".localizeString()
//    
//}



import UIKit
import CoreImage

enum CodeType {
    case qrCode
    case barCode128
}

extension String {
    
    func toCodeImage(type: CodeType) -> UIImage? {
        let data: Data?
        
        switch type {
        case .qrCode:
            data = self.data(using: .utf8)
        case .barCode128:
            data = self.data(using: .ascii)
        }
        
        guard let inputData = data else { return nil }
        
        let filterName: String
        
        switch type {
        case .qrCode:
            filterName = "CIQRCodeGenerator"
        case .barCode128:
            filterName = "CICode128BarcodeGenerator"
        }
        
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

