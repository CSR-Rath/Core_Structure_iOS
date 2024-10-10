//
//  UIImage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import UIKit

//MARK: Set circle imageview
extension UIImage {
    
    
    //សមាមាត្រ
    func getImageRatio(view:UIView ) -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return view.frame.width / imageRatio
    }
    
    
    
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
}
