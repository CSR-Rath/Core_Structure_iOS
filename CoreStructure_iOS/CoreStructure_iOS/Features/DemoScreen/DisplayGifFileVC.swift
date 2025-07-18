//
//  GifViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/3/25.
//

import Foundation
import UIKit

class DisplayGifFileVC: UIViewController {
    
    var imgGit = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        displayGifRight(imgRight: imgGit)
    }
    
    
    func displayGifRight(imgRight : UIImageView ) {
        // Get the path for the GIF file
        guard let path = Bundle.main.path(forResource: "loadingGif", ofType: "gif") else {
            print("GIF file not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        
        // Load the GIF data
        guard let gifData = try? Data(contentsOf: url) else {
            print("Unable to load GIF data")
            return
        }
        
        // Create an image view
        let imageView = imgRight
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.animationImages = loadGifImages(data: gifData)
        imageView.animationDuration = 1.0 // Set duration for full loop
        imageView.startAnimating()
        
        // Add the image view to the view
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor,constant: -70),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),
        ])
        
    }
    
    private func loadGifImages(data: Data) -> [UIImage] {
        var images: [UIImage] = []
        let source = CGImageSourceCreateWithData(data as CFData, nil)!
        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        return images
    }
}
