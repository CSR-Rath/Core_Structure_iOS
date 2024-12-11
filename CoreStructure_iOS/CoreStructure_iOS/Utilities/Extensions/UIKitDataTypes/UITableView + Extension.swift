//
//  UITableView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import Foundation
import UIKit


//MARK: Handle tableView list
extension UITableView{

    func setEmptyView(title: String = "Data Not Found", messageImage: UIImage = .imgEmptyList) {
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
        
        // Set background view and separator style
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        // Restore the original table view state
        self.backgroundView = nil
        self.separatorStyle = .singleLine
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

//MARK: Pagination fetch data
extension UITableView{
    
    func showLoadingSpinner(with title: String = "Fetch data.") {
        // Add a loading spinner and title to the table view
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = .red
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [spinner, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0,
                                                 width: self.bounds.width,
                                                 height: titleLabel.frame.height + spinner.frame.height + 16))
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        
        self.tableFooterView = containerView
    }
    
    func hideLoadingSpinner() {
        // Remove the loading spinner from the table view
        self.tableFooterView = nil
    }
}


import UIKit

class CustomRefreshControl: UIRefreshControl {
    
    private let customIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Add the custom icon to the refresh control
        self.addSubview(customIcon)
        
        // Set constraints for the icon
        NSLayoutConstraint.activate([
            customIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            customIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            customIcon.widthAnchor.constraint(equalToConstant: 30), // Adjust size
            customIcon.heightAnchor.constraint(equalToConstant: 30) // Adjust size
        ])
    }
    
    // Function to set the icon image
    func setIcon(image: UIImage?) {
        customIcon.image = image
    }
    
    override func beginRefreshing() {
        setIcon(image: .icFaceID)
        super.beginRefreshing()
        // You can start animations here if needed
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        // Stop animations here if needed
        
    }
}
