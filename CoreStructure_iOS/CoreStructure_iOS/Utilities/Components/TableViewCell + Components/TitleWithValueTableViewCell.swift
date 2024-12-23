//
//  TitleWithValueTableViewCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 14/8/24.
//

import Foundation
import UIKit


class TitleWithValueCell: UITableViewCell {

   static let identifier = "TitleWithValueCell"
     let stack = UIStackView()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "_"
        lbl.autoWidthInStack()
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
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        stack.addArrangedSubview(lblTitle)
        stack.addArrangedSubview(lblValue)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
        ])
    }
}
