//
//  RoomTableViewCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/12/24.
//

import UIKit


class RoomTableViewCell: UITableViewCell {
    
    let roomNameLabel = UILabel()
    let roomAvailabilityLabel = UILabel()
    let roomType = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        roomNameLabel.numberOfLines = 0
        roomAvailabilityLabel.numberOfLines = 0
        roomNameLabel.translatesAutoresizingMaskIntoConstraints = false
        roomAvailabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        roomType.translatesAutoresizingMaskIntoConstraints = false
        
        roomType.fontBold(16)
        roomType.textColor = .systemGreen
        
        roomNameLabel.fontMedium(16)
        roomAvailabilityLabel.fontMedium(16)
        
        contentView.addSubview(roomNameLabel)
        contentView.addSubview(roomAvailabilityLabel)
        contentView.addSubview(roomType)
        
        
        // Layout your labels here
        NSLayoutConstraint.activate([
            roomNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            roomNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            roomAvailabilityLabel.topAnchor.constraint(equalTo: roomNameLabel.bottomAnchor, constant: 10),
            roomAvailabilityLabel.leadingAnchor.constraint(equalTo: roomNameLabel.leadingAnchor),
            roomAvailabilityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -10),
            
            roomType.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            roomType.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
        ])
    }
}
