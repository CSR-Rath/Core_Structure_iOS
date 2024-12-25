//
//  ExpandedMultipleSectionCell.swift
//  iOS_For_Learning
//
//  Created by  Rath! on 29/8/23.
//

import Foundation
import UIKit


class ExpandableTableViewCell: UITableViewCell {
    
    static var identifier = "ExpandableTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
     
    private func setupUI(){
        // Add views to the cell's content view
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
