//
//  UICollectionView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import UIKit


// MARK: - Handle list collectionView
extension UICollectionView {
    
    func setEmptyView(title: String = "Data Not Found", messageImage: UIImage) {
        // Create the empty view
        let emptyView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: self.bounds.size.width,
                                             height: self.bounds.size.height))
        
        // Create the image view
        let messageImageView = UIImageView()
        messageImageView.image = messageImage
        messageImageView.contentMode = .scaleAspectFill
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14) // Set the font
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(titleLabel)
        
        // Set constraints
        NSLayoutConstraint.activate([
            messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50),
            messageImageView.widthAnchor.constraint(equalToConstant: 100),
            messageImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
        
        // Add animation to the image view
        animateImageView(messageImageView)
        
        // Set the background view of the collection view
        self.backgroundView = emptyView
    }
    
    func restore() {
        // Restore the original collection view state
        self.backgroundView = nil
    }
    
    private func animateImageView(_ imageView: UIImageView) {
        UIView.animate(withDuration: 1.0, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: -(.pi / 10))
            }, completion: { _ in
                UIView.animate(withDuration: 1.0, animations: {
                    imageView.transform = .identity
                })
            })
        })
    }
}
