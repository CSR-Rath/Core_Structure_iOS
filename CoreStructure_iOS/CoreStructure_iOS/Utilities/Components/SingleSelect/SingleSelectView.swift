//
//  SingleSelectView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/4/25.
//

import Foundation
import UIKit

class SingleSelectView: UIView {
    var didSelectCell:((Int)->())?
    var defaultSelect: Int = 0{
        didSet{
            
        }
    }
    
    let layout = UICollectionViewFlowLayout()
    
    var itemsList : [String] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var nsConstraint = NSLayoutConstraint()
    
    var height: CGFloat = 35{
        didSet{
            nsConstraint.isActive = false
            nsConstraint.constant = height
            nsConstraint.isActive = true
        }
    }
    
    
    lazy var collectionView : UICollectionView = {
        
        layout.scrollDirection = .horizontal
        let colloection = UICollectionView(frame: .zero,
                                           collectionViewLayout: layout)
        colloection.translatesAutoresizingMaskIntoConstraints = false
        colloection.showsHorizontalScrollIndicator = false
        colloection.register(SingleSelectCell.self,
                             forCellWithReuseIdentifier: SingleSelectCell.cell)
        colloection.dataSource = self
        colloection.delegate = self
        colloection.backgroundColor = .clear
        return colloection
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if defaultSelect < itemsList.count{
            let index = IndexPath(item: defaultSelect, section: 0)
            collectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstrain()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstrain(){
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
        nsConstraint = heightAnchor.constraint(equalToConstant: 35)
        nsConstraint.isActive = true
    }
}


extension SingleSelectView: UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleSelectCell.cell, for: indexPath) as! SingleSelectCell
        cell.lblTitle.text  = itemsList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = calculateWidth(for: itemsList[indexPath.item])
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("value  selected ==> : " , itemsList[indexPath.item] )
        defaultSelect = indexPath.row
        didSelectCell?(indexPath.item)
    }
}


class SingleSelectCell: UICollectionViewCell {
    
    static let cell = "SingleSelectCell"
    
    lazy var circleView: UIImageView = {
        let lbl = UIImageView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .clear
        lbl.layer.cornerRadius = 10
        lbl.layer.borderWidth = 1.5
        lbl.layer.borderColor = UIColor.gray.cgColor
        return lbl
    }()
    
    lazy var lblTitle: UILabel = {
        let lblTitle = UILabel()
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.text = "_"
        lblTitle.fontRegular(14)
        lblTitle.textColor = .black
        return lblTitle
    }()
    
    
    override var isSelected: Bool{
        didSet{
            
            if isSelected{
                lblTitle.fontBold(14)
                circleView.backgroundColor = .black
            }else{
                lblTitle.fontRegular(14)
                circleView.backgroundColor = .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIView()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIView(){
        addSubview(circleView)
        addSubview(lblTitle)
        
        NSLayoutConstraint.activate([
            
            circleView.heightAnchor.constraint(equalToConstant: 20),
            circleView.widthAnchor.constraint(equalToConstant: 20),
            circleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            lblTitle.rightAnchor.constraint(equalTo: rightAnchor),
            lblTitle.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 5),
            lblTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension UIView{
    func calculateWidth(for text: String?) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17)
        let attributes = [NSAttributedString.Key.font: font]
        let size = text?.size(withAttributes: attributes) ?? CGSize.zero
        return size.width + 40
    }
}
