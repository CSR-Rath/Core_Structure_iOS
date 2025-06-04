//
//  ImageSlideshowView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/6/25.
//

import UIKit
import ImageSlideshow
import Kingfisher
import ImageSlideshowKingfisher


let baseURLRoadImageRoyalty = ""

class ImageSlideshowView: UIView, ImageSlideshowDelegate {
    
    // MARK: - Properties
    
    private var localSource: [InputSource] = []
    
    var featureStore: [Store]? {
        didSet {
            updateSlideshowImages()
        }
    }

    // MARK: - UI Components
    
    private lazy var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        slideshow.slideshowInterval = 5.0
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.layer.cornerRadius = 25
        slideshow.layer.masksToBounds = true
        slideshow.backgroundColor = .darkGray
        slideshow.circular = true
        slideshow.delegate = self
        return slideshow
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(slideshow)
        NSLayoutConstraint.activate([
            slideshow.topAnchor.constraint(equalTo: topAnchor),
            slideshow.bottomAnchor.constraint(equalTo: bottomAnchor),
            slideshow.leadingAnchor.constraint(equalTo: leadingAnchor),
            slideshow.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    // MARK: - Image Loading Logic
    
    private func updateSlideshowImages() {
        localSource.removeAll()
        
        guard let dataList = featureStore else {
            print("==> featureStore is nil.")
            setFallbackImage()
            return
        }
        
        for data in dataList {
            let imagePath = data.bannerEnFile ?? ""
            let imageURLString = baseURLRoadImageRoyalty + imagePath
            
            if let source = KingfisherSource(
                urlString: imageURLString,
                placeholder: UIImage(named: "img_thumbnail")
            ) {
                localSource.append(source)
                print("imageURL ==> \(imageURLString)")
            } else if let fallback = UIImage(named: "img_thumbnail") {
                localSource.append(ImageSource(image: fallback))
                print("Fallback used for: \(imageURLString)")
            }
        }
        
        if localSource.isEmpty {
            setFallbackImage()
        }
        
        slideshow.setImageInputs(localSource)
    }
    
    private func setFallbackImage() {
        if let fallback = UIImage(named: "img_thumbnail") {
            localSource = [ImageSource(image: fallback)]
            slideshow.setImageInputs(localSource)
        }
    }
    
    // MARK: - Delegate
    
    func imageSlideshow(_ slideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("Slideshow page changed to: \(page)")
    }
}


struct Store: Codable{
    var bannerEnFile: String?
}
