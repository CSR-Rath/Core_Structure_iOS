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


extension UIImageView {
    
    func loadingImage(urlString: String,
                      defaultImage: UIImage = .imgEmpty,
                      style: UIActivityIndicatorView.Style = .medium ) {
        // Create and configure the activity indicator
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = .blue
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the activity indicator to the image view
        self.addSubview(activityIndicator)
        
        // Center the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // Start animating the activity indicator
        activityIndicator.startAnimating()
        
        // Set the default image while loading
        self.image = defaultImage
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            return
        }
        
        // Fetch the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                if let error = error {
                    print("Error loading image: \(error)")
                    self.image = defaultImage // Set default image on error
                    return
                }
                
                // Check for valid data and create the image
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.image = image // Set the loaded image
                } else {
                    self.image = defaultImage // Set default image if data is invalid
                }
            }
        }.resume()
    }
}
