//
//  UIImageView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import Foundation
import UIKit


extension UIImageView {
    
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
    
}



//cell.imgLogo.imageFromURL(urlString: data.url ?? "")
extension UIImageView {
    public func imageFromURL(urlString: String, defaultImage: UIImage = UIImage(named: "img")!) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .blue
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        
        // Center the activity indicator
        let centerXConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([centerXConstraint, centerYConstraint])
        
        activityIndicator.startAnimating()
        
        if self.image == nil {
            self.image = defaultImage // default background before call get url image.
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
                return
            }

            DispatchQueue.main.async(execute: { () -> Void in
                if let imageData = data, let image = UIImage(data: imageData) {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    self.image = image // success image.
                } else {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    self.image = .add // set default image is nil.
                }
            })
        }).resume()
    }
}
