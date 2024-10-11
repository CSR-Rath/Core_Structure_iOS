//
//  BoardTableViewCell.swift
//  LOS
//
//  Created by Rath! on 11/9/24.
//

import UIKit

class BoardTableViewCell: UITableViewCell {
    
    static let identifier = "BoardTableViewCell"
    
//    lazy var containView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 10
//        view.backgroundColor = .white
//        return view
//    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        layer.cornerRadius  = 10
       

        setupConstrant()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: Setup constraint UIView
extension BoardTableViewCell{
    
    private func setupConstrant(){
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        
        
        NSLayoutConstraint.activate([
        
            contentView.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            contentView.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
            contentView.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),
            contentView.heightAnchor.constraint(equalToConstant: 180),
        
        ])
        
    }
}
