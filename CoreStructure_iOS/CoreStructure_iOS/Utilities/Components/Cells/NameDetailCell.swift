//
//  NameDetailCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 14/8/24.
//

import Foundation
import UIKit

struct NameDetailModel{
    let name: String
    let detail: String
}

class NameDetailCell: UITableViewCell {
    
    static let identifier = "NameDetailCell"
    let stackLabel = UIStackView()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "_"
        lbl.adjustSizeToFitContent()
        lbl.fontRegular(14)
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var lblValue: UILabel = {
        let lbl = UILabel()
        lbl.text = "_"
        lbl.textAlignment = .right
        lbl.fontRegular(14)
        lbl.textColor = .black
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupview(){
        stackLabel.axis = .horizontal
        stackLabel.spacing = 0
        stackLabel.alignment = .fill
        stackLabel.distribution = .fill
        stackLabel.addArrangedSubview(lblTitle)
        stackLabel.addArrangedSubview(lblValue)
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        stackLabel.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackLabel.isLayoutMarginsRelativeArrangement = true
        addSubview(stackLabel)
        
        NSLayoutConstraint.activate([
            stackLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            stackLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            stackLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
    }
}
