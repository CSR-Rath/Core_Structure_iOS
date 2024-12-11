//
//  CategoryCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/11/24.
//

import UIKit

var isPython : Bool = true

class CategoryCell: UITableViewCell {
    
    var didSelectItemsCell:((Int)->())?
    let screen = UIScreen.main.bounds.width
    var width = 0
    
    var dataList :  [TitleValueModel] = [
        TitleValueModel(title: "Geusts", value: "imgGeusts"),
        TitleValueModel(title: "Rooms", value: "imgRoom"),
        TitleValueModel(title: "Reservation", value: "imgReservation"),
        TitleValueModel(title: "Histories", value: "imgHistory"),
    ] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(CotegoryItemCall.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        width =  Int((screen-45)/2)
        
        contentView.isUserInteractionEnabled = false
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: screen),
            collectionView.topAnchor.constraint(equalTo: topAnchor,constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func updateCollectionViewHeight(with itemCount: Int) {
        let itemHeight: CGFloat = 90 // Height of each collection view item
        let spacing: CGFloat = 10      // Spacing between items
        let totalHeight = CGFloat(itemCount) * (itemHeight + spacing) - spacing
        collectionView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
}

extension CategoryCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count // Return the number of items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CotegoryItemCall
        cell.backgroundColor = .mainColor // Customize your cell
        cell.layer.cornerRadius = 5
        
        let data = dataList[indexPath.item]
        
        cell.imgLogo.image = UIImage(named: data.value)
        cell.lblName.text = data.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        didSelectItemsCell?(indexPath.item)
    }
}

class CotegoryItemCall: UICollectionViewCell{
    
    let lblName = UILabel()
    let imgLogo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        
        
        addSubview(imgLogo)
        imgLogo.translatesAutoresizingMaskIntoConstraints = false
        imgLogo.contentMode = .scaleAspectFill
        imgLogo.image = .icClose
        
        addSubview(lblName)
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.text = "_"
        lblName.textAlignment = .center
        lblName.numberOfLines = 0
        lblName.fontSemiBold(20)
        
        NSLayoutConstraint.activate([
            
            imgLogo.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -30),
            imgLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            imgLogo.heightAnchor.constraint(equalToConstant: 100),
            imgLogo.widthAnchor.constraint(equalToConstant: 100),
            
            lblName.topAnchor.constraint(equalTo: imgLogo.bottomAnchor,constant: 15),
            lblName.leftAnchor.constraint(equalTo: leftAnchor),
            lblName.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}
