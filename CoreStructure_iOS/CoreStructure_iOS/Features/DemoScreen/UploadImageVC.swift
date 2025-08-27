//
//  UploadImageViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/4/25.
//

import UIKit
import UIKit

class UploadImageVC: BaseUIViewConroller {
    
    private let imagePicker = BaseUIImagePickerController()
    private var imageHeightConstraint = NSLayoutConstraint()

    // Lazy initialization for imageView
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Image", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Upload Image"
        setupLayout()
        
        selectImageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        
        // Handle image pick
        imagePicker.didPickImage = { [self]  image , percentageHeight in
            
            print("percentageHeight ==> \(percentageHeight)")
           
            self.imageView.image = image
      
            self.imageHeightConstraint.isActive = false
            self.imageHeightConstraint = self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: percentageHeight)
            self.imageHeightConstraint.isActive = true
        }
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(selectImageButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate the initial height constraint
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 250)
        imageHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            selectImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func selectImageTapped() {
        imagePicker.presentChooseOption(from: self)
    }
}
