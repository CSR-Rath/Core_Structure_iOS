//
//  ProductCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/4/25.
//

import Foundation
import UIKit

//class ProductCell: UITableViewCell{
//     
//    static let  cell = "ProductCell"
//    
//    let lblName = UILabel()
//    let lblPrice = UILabel()
//    let lblQty = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupUI(){
//        
//       
//        
//        let lblAll =  [lblName, lblPrice , lblQty]
//        
//        lblAll.forEach({ item in
//            item.textColor = .black
//            item.translatesAutoresizingMaskIntoConstraints = false
//            item.fontRegular(16)
//            addSubview(item)
//        })
//        
//        NSLayoutConstraint.activate([
//        
//            lblName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            lblName.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
//        
//            lblPrice.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 10),
//            lblPrice.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//            lblPrice.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
//            
//            lblQty.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            lblQty.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
//        
//        ])
//    }
//}
