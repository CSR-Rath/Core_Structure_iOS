//
//  DateCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/6/25.
//

import UIKit

class DateCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.fontRegular(14)
        label.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with date: Date, isSelected: Bool, isStart: Bool, isEnd: Bool) {
        let calendar = Calendar.current
        
        if date == Date.distantPast {
            label.text = ""
            reloadColor(color: .clear)
            label.layer.cornerRadius = 0
            return
        }
        
        let day = calendar.component(.day, from: date)
        label.text = "\(day)"
        label.layer.cornerRadius = label.frame.width/2
        
        if isStart || isEnd {
            
            label.backgroundColor = .orange
            label.textColor = .white
            
        } 
        else if isSelected {
            
            label.textColor = .black
            let color =  UIColor.orange.withAlphaComponent(0.3)
            reloadColor(color: color)
            
        } 
        else {
            
            reloadColor(color: .clear)
            label.textColor = .black
        }
    }
    
    private func reloadColor(color: UIColor){
        
        label.backgroundColor = color
    }
}
