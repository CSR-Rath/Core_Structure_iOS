//
//  UIImageView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import Foundation
import UIKit

enum imageLoadingTypeEnum: String{
    case imageEmpty = "imgEmpty"
    case imageEmptyList = "imgEmptyList"
    case imageUser = "imgUserLoading"
}


extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func isLoadingImage(urlString: String,
                      defaultImage: imageLoadingTypeEnum,
                      style: UIActivityIndicatorView.Style = .medium,
                      isHaveToken: Bool = false // ✅ Optional token parameter
    ) {
        // Create and configure the activity indicator
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = .blue
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        let gotImage = UIImage(named: defaultImage.rawValue)
        self.image = gotImage
        
        guard let url = URL(string: urlString) else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.image = gotImage
            return
        }
        
        // ✅ Create URLRequest and add token if available
        var request = URLRequest(url: url)
        
        if isHaveToken{
            for (headerField, headerValue) in getHeader() {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        // ✅ Use custom URLSession request with token
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                if let error = error {
                    print("Error loading image: \(error)")
                    self.image = gotImage
                    self.contentMode = .scaleAspectFill
                    return
                }
                
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.image = image
                } else {
                    self.image = gotImage
                }
            }
        }.resume()
    }
}

let imageCache = NSCache<NSString, UIImage>()


extension UIImageView {
    func loadCachedImage(
        from urlString: String,
        placeholder: UIImage? = UIImage(named: "placeholder") // default image
    ) {
        // Show placeholder first
        self.image = placeholder
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .blue
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        // Check cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            return
        }
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.image = placeholder
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            
            if let error = error {
                print("❌ Image load failed:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.image = placeholder
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.image = placeholder
                }
                return
            }
            
            // Save to cache
            imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}




