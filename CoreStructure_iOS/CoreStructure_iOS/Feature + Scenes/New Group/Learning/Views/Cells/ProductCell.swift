//
//  ProductCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/11/24.
//

import Foundation
import UIKit

enum IsFromProductCell{
    case makeOrder
    case productList
}

class ProductCell : UITableViewCell{

    var didTappedButton: (()->())?
    
    var didTappedDelete: (()->())?
    var didTappedEdit: (()->())?
    
    let lblPrice = UILabel()
    let lblName =  UILabel()
    let lblStock =  UILabel()
    let imgLogo = UIImageView()
    let imgCircle = UIImageView()
    var lblCount = UILabel()
    
    var decrementAndIncrement: Int = 1 {
        didSet{
            lblCount.text = "\(decrementAndIncrement)"
        }
    }
    
    let btnDelete = MainButton()
    let btnUpdate = MainButton()
    
    var isFromProductCell : IsFromProductCell = .productList {
        didSet{
            handleButton()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ProductCell{
    
        @objc  func decrementValue(_ sender: UIButton){
    
            if decrementAndIncrement > 1{
                decrementAndIncrement -= 1
                didTappedButton?()
            }
        }
    
        @objc func incrementValue(_ sender: UIButton){
            
            decrementAndIncrement += 1
            didTappedButton?()
        }
    
    
    private func  handleButton(){
        btnDelete.backgroundColor = .clear
        btnUpdate.backgroundColor = .clear
        
         if isFromProductCell == .productList {
             
             btnDelete.setImage(.icDelete, for: .normal)
             btnDelete.setTitleColor(.white, for: .normal)
             btnDelete.layer.cornerRadius = 5
             btnDelete.titleLabel?.fontMedium(10)
             
             btnUpdate.layer.cornerRadius = 5
             btnUpdate.setImage(.icEdit, for: .normal)
             btnUpdate.setTitleColor(.white, for: .normal)
             btnUpdate.titleLabel?.fontMedium(10)
             
             btnDelete.addTargetButton(target: self, action: #selector(decrementValue))
             btnUpdate.addTargetButton(target: self, action: #selector(incrementValue))
             
             imgCircle.isHidden = false
             lblCount.isHidden = true
             
         }else{

             btnDelete.setTitle("-", for: .normal)
            
             btnDelete.layer.borderWidth = 2
             btnDelete.layer.borderColor = UIColor.mainBlueColor.cgColor
             btnDelete.setTitleColor(.mainBlueColor, for: .normal)
             btnDelete.layer.cornerRadius = 15
             btnDelete.titleLabel?.fontMedium(30)
             btnDelete.setImage(UIImage(), for: .normal)
             
             btnUpdate.setTitle("+", for: .normal)
            
             btnUpdate.layer.borderWidth = 2
             btnUpdate.layer.borderColor = UIColor.mainBlueColor.cgColor
             btnUpdate.setTitleColor(.mainBlueColor, for: .normal)
             btnUpdate.layer.cornerRadius = 15
             btnUpdate.titleLabel?.fontMedium(30)
             btnUpdate.setImage(UIImage(), for: .normal)
             
             lblCount.textColor = .orange
             lblCount.fontBold(25)
             
             imgCircle.isHidden = true
             lblCount.isHidden = false
        
         }
     }
    
    private func setupUI(){
        
        let stackButtomn = UIStackView(arrangedSubviews: [btnDelete,lblCount,btnUpdate,imgCircle])
        stackButtomn.axis = .horizontal
        stackButtomn.spacing = 10
        stackButtomn.distribution = .fill
        stackButtomn.alignment = .center
        
        btnUpdate.layer.cornerRadius = 5
        btnDelete.layer.cornerRadius = 5
        lblCount.text = "\(decrementAndIncrement)"
        handleButton()

        addSubview(imgLogo)
        addSubview(lblPrice)
        addSubview(lblName)
        addSubview(lblStock)
        
        addSubview(stackButtomn)
    
        
        imgLogo.translatesAutoresizingMaskIntoConstraints = false
        lblPrice.translatesAutoresizingMaskIntoConstraints = false
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblStock.translatesAutoresizingMaskIntoConstraints = false
        stackButtomn.translatesAutoresizingMaskIntoConstraints = false
        
        imgLogo.backgroundColor = .lightGray
        imgLogo.layer.cornerRadius = 80/2
        imgLogo.contentMode = .scaleAspectFit
        
        
        imgCircle.layer.cornerRadius = 25/2
        imgCircle.layer.borderWidth = 2
        imgCircle.backgroundColor = .clear
        imgCircle.layer.borderColor = UIColor.gray.cgColor
        
        NSLayoutConstraint.activate([
        
            imgLogo.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            imgLogo.heightAnchor.constraint(equalToConstant: 80),
            imgLogo.widthAnchor.constraint(equalToConstant: 80),
            imgLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackButtomn.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackButtomn.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
            btnDelete.widthAnchor.constraint(equalToConstant: 30),
            btnDelete.heightAnchor.constraint(equalToConstant: 30),
            
            btnUpdate.heightAnchor.constraint(equalToConstant: 30),
            btnUpdate.widthAnchor.constraint(equalToConstant: 30),

            imgCircle.heightAnchor.constraint(equalToConstant: 25),
            imgCircle.widthAnchor.constraint(equalToConstant: 25),

            lblPrice.topAnchor.constraint(equalTo: imgLogo.topAnchor,constant: 10),
            lblPrice.leftAnchor.constraint(equalTo: imgLogo.rightAnchor,constant: 10),
            
            lblName.bottomAnchor.constraint(equalTo: imgLogo.bottomAnchor,constant: -10),
            lblName.leftAnchor.constraint(equalTo: imgLogo.rightAnchor,constant: 10),
            
            lblStock.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            lblStock.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),

        ])

    }
}
