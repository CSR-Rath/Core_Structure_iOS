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
    
    // loadingImage = use loading SDWebImage 
    func loadingImage(urlString: String,
                      defaultImage: imageLoadingTypeEnum = .imageEmpty,
                      style: UIActivityIndicatorView.Style = .medium
                      
    ) {
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
        
        let gotImage = UIImage(named: defaultImage.rawValue)
        
        // Set the default image while loading
        self.image = gotImage
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.image = gotImage // Set default image on invalid URL
            return
        }
        
        // Fetch the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                // Stop the activity indicator and remove it from the view
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                if let error = error {
                    print("Error loading image: \(error)")
                    self.image = gotImage // Set default image on error
                    self.contentMode = .scaleAspectFill
                    return
                }
                
                // Check for valid data and create the image
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.image = image // Set the loaded image
                } else {
                    self.image = gotImage // Set default image if data is invalid
                }
            }
        }.resume()
    }
}


extension UIImageView {

    func loadingImage(urlString: String,
                      defaultImage: imageLoadingTypeEnum = .imageEmpty,
                      style: UIActivityIndicatorView.Style = .medium,
                      token: String? = nil // ✅ Optional token parameter
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
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
