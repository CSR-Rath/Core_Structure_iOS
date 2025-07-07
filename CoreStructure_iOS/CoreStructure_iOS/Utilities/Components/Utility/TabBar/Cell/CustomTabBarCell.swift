//
//  CustomTabBarCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit

class CustomTabBarCell: UICollectionViewCell {
    
    static let identifier: String = "CustomTabBarCell"
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.textColor = .black
        lbl.fontRegular(13)
        return lbl
    }()
    
    lazy var imgIcon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imgIcon,lblTitle])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupConstrain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupConstrain(){
        imgIcon.layer.cornerRadius = 35/2
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),

            imgIcon.heightAnchor.constraint(equalToConstant: 25),
            imgIcon.widthAnchor.constraint(equalToConstant: 25),
        ])
    }
}
