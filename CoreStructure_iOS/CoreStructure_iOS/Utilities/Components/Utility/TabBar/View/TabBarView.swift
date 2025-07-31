//
//  TabBarView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 20/6/25.
//

import Foundation
import UIKit

class TabBarView: UIView{
    
    var indexDidChange:((_ index: Int)->())?
    
    var indexSelected: Int = 0 {
        didSet{
            collactionView.reloadData()
        }
    }
    
    var dataList : [TitleIconModel] = [
        TitleIconModel(name: "VC", iconName: ""),
        TitleIconModel(name: "Package", iconName: ""),
        TitleIconModel(name: "Button", iconName: ""),
        TitleIconModel(name: "Padding", iconName: ""),
        TitleIconModel(name: "Find", iconName: ""),
    ] {
        didSet{
            collactionView.reloadData()
        }
    }
    
     lazy var collactionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(CustomTabBarCell.self, forCellWithReuseIdentifier: CustomTabBarCell.identifier)
        return collection
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSizeForItems()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraintAndSetupController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSizeForItems(){
        
        if let layout = collactionView.collectionViewLayout as? UICollectionViewFlowLayout { // handle cell items
            
            let screen = UIScreen.main.bounds.width
            let spac: CGFloat = 10
            let spacing = CGFloat(dataList.count-1) * spac
            let itemWidth = (screen-spacing) / CGFloat(dataList.count)
            let itemHeight = collactionView.frame.height
            
            layout.minimumLineSpacing = spac
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
        
    }
    
    private func setupConstraintAndSetupController(){
        backgroundColor = .clear
        addSubview(collactionView)
        NSLayoutConstraint.activate([
            collactionView.topAnchor.constraint(equalTo: topAnchor),
            collactionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collactionView.rightAnchor.constraint(equalTo: rightAnchor),
            collactionView.leftAnchor.constraint(equalTo: leftAnchor),
        
        ])
    }
    

}


//MARK: Delegate and Datasource
extension TabBarView:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomTabBarCell.identifier, for: indexPath) as! CustomTabBarCell
        
        cell.lblTitle.text = dataList[indexPath.item].name
        
        cell.imgIcon.image = UIImage(systemName: "swift" )
        
        if indexSelected  == indexPath.item {
            configureSelectedCell(cell)
        } else {
            configureDeselectedCell(cell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexSelected != indexPath.item{
            indexSelected = indexPath.item
            indexDidChange?(indexPath.item)
        }
    }
    
}

private func configureSelectedCell(_ cell: CustomTabBarCell) {
    cell.imgIcon.setImageColor(color: .white)
    cell.lblTitle.fontBold(13, color: .white)
    animateCellSelection(cell)
}

private func configureDeselectedCell(_ cell: CustomTabBarCell) {
    cell.imgIcon.setImageColor(color: .gray)
    cell.lblTitle.fontRegular(13,color: .gray)
}

private func animateCellSelection(_ cell: CustomTabBarCell) {
    UIView.animate(withDuration: 0.05, animations: {
        cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        cell.backgroundColor = .white.withAlphaComponent(0.1)
    }, completion: { _ in
        UIView.animate(withDuration: 0.05) {
            cell.transform = CGAffineTransform.identity
            cell.backgroundColor = .clear
        }
    })
}


struct TitleIconModel{
    let name: String
    let iconName: String
}
