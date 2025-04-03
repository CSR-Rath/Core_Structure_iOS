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
extension String{
   
    static let  confirmlLocalizable  = "confirm".localizeString()
    
}




extension String{
    
    func toQRCode() -> UIImage? {
        
        let data = self.data(using: String.Encoding.utf8)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
            
            filter.setValue(data, forKey: "inputMessage")
            
            colorFilter.setValue(filter.outputImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(color: UIColor.clear), forKey: "inputColor1") // Background clear
            colorFilter.setValue(CIColor(color: UIColor.black), forKey: "inputColor0") // Foreground or the barcode black
            let transform = CGAffineTransform(scaleX: 15, y: 15)
            
            
            if let output = colorFilter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }


    func toBarcode() -> UIImage? {
        guard let data = self.data(using: .ascii) else { return nil }

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            // Ensure the barcode image is generated
            guard let barcodeImage = filter.outputImage else { return nil }

            // Scale up for better resolution
            let transform = CGAffineTransform(scaleX: 15, y: 15) // Adjust scale as needed
            let scaledImage = barcodeImage.transformed(by: transform)

            return UIImage(ciImage: scaledImage)
        }
        
        return nil
    }
}
