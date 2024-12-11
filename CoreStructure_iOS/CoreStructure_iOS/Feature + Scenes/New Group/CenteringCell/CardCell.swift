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
    
    lazy var lblNumer: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "000 000 001"
        lbl.textColor = .white
        lbl.fontBold(16)
        return lbl
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
        addSubview(lblNumer)
        
        
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            customView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            
            lblNumer.centerXAnchor.constraint(equalTo: centerXAnchor),
            lblNumer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }
}
