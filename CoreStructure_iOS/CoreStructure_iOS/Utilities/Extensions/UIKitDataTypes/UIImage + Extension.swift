//
//  UIImage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import UIKit

//MARK: Set circle imageview
extension UIImage {
    
    func roundedImage() -> UIImage? {
        let imageSize = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let imageBounds = CGRect(origin: .zero, size: imageSize)
        let path = UIBezierPath(roundedRect: imageBounds, cornerRadius: imageSize.width / 2.0)
        
        path.addClip()
        draw(in: imageBounds)
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    func imageToString() -> String {
        guard let image = CIImage(image: self) else {
            return "==> Empty Stirng"
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: image) ?? []
        return features.compactMap { feature in
            return (feature as? CIQRCodeFeature)?.messageString
        }.joined()
    }
}
