//
//  CardCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/10/24.
//

import UIKit

class CardCell: UICollectionViewCell {
    let customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint(){
        
        addSubview(customView)
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            customView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
        ])
    }
}
