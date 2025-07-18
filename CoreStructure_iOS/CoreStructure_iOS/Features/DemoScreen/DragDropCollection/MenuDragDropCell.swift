//
//  MenuDragDropCell.swift
//  DragDropCollectionView
//
//  Created by Rath! on 7/5/24.
//

import UIKit


class MenuDragDropCell: UICollectionViewCell {
    
    var nsWidth = NSLayoutConstraint()
    var nsHeight = NSLayoutConstraint()
    
    var sizeImage:CGFloat = 64{
        didSet{

            updateImageSizeConstraints()
        }
    }
    
    
    let imgIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        backgroundColor = .clear
        layer.cornerRadius = 10
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    var tapAction: (() -> Void)?
    @objc private func handleTap() {
           // Call the tapAction if it exists
        print("handleTap")
           tapAction?()
       }
    
    
    private func setupViews() {
        // Add and configure subviews
        contentView.addSubview(imgIcon)
        contentView.addSubview(titleLabel)
        
        // Configure constraints
        imgIcon.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        nsHeight = imgIcon.heightAnchor.constraint(equalToConstant: sizeImage)
        nsWidth =   imgIcon.widthAnchor.constraint(equalToConstant: sizeImage)
        
        nsHeight.isActive = true
        nsWidth.isActive = true
        
        NSLayoutConstraint.activate([
            imgIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            imgIcon.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8)
        ])
    }
    
    private func updateImageSizeConstraints() {
            // Deactivate old constraints before updating
            nsHeight.isActive = false
            nsWidth.isActive = false
            
            nsHeight = imgIcon.heightAnchor.constraint(equalToConstant: sizeImage)
            nsWidth = imgIcon.widthAnchor.constraint(equalToConstant: sizeImage)
            
            nsHeight.isActive = true
            nsWidth.isActive = true
        }
}
