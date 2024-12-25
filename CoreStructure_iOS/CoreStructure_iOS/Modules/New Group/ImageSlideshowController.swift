//
//  ImageSlideshowController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 25/12/24.
//

import UIKit


var images: [String] = [
    "https://skyryedesign.com/wp-content/uploads/2024/05/56a7fdf8e3b037f64c5f517e74cd40e0-576x1024.jpg",
    "https://i.pinimg.com/736x/95/2f/6b/952f6b4c1c7f95b6a222732abde3dd9a.jpg",
    "https://i.pinimg.com/236x/e1/b4/9f/e1b49fbf6e9bb5b19b2a214472d0c3c7.jpg"
]

class SlideshowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
  
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        
        startSlideshow()
    }

    func startSlideshow() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self,
                                     selector: #selector(nextSlide),
                                     userInfo: nil, repeats: true)
    }

    @objc func nextSlide() {
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.frame.width)
        let nextIndex = (currentIndex + 1) % images.count
        let indexPath = IndexPath(item: nextIndex, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageView.loadingImage(urlString: images[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    deinit {
        timer?.invalidate()
    }
}

class ImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
