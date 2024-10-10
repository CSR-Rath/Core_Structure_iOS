//
//  CustomTabBarVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit



class CustomTabBarVC: UITabBarController {
    
    //declaring a singleton
//    let shared = CustomTabBarVC()
    
    var indexSelected: Int = 0{
        didSet{
            self.selectedIndex = indexSelected
            collactionView.reloadData()
        }
    }
    
    lazy var collactionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .orange
        collection.delegate = self
        collection.dataSource = self
        collection.register(CustomTabBarCell.self, forCellWithReuseIdentifier: CustomTabBarCell.identifier)
        return collection
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.isHidden = true
        setupConstraintAndSetupController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //MARK: Setup items size collection view
        if let layout = collactionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            let itemWidth = (view.bounds.width-30) / 4
            let itemHeight = collactionView.frame.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
    //MARK: Handle Setup ViewController
    private func setupConstraintAndSetupController(){
        
        let firstVC = FirstViewController()
        let secondVC = SecondViewController()
        let threeVC = ThreeViewController()
        let fourtVC = FourViewController()
        
        viewControllers = [firstVC, secondVC, threeVC, fourtVC]
        
        view.addSubview(collactionView)
        NSLayoutConstraint.activate([
        
            collactionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collactionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collactionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collactionView.heightAnchor.constraint(equalToConstant: 85),
        
        ])
    }
}




//MARK: Delegate and Datasource
extension CustomTabBarVC:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomTabBarCell.identifier,
                                                      for:  indexPath) as! CustomTabBarCell
        
        if indexSelected  == indexPath.item {
            configureSelectedCell(cell)
        } else {
            configureDeselectedCell(cell)
        }
        
        cell.imgIcon.image = UIImage(systemName: "\(indexPath.item+1).circle")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexSelected = indexPath.item
    }
}

//MARK: Handle Cell conditions

private func configureSelectedCell(_ cell: CustomTabBarCell) {
    cell.lblTitle.text = "test"
    cell.imgIcon.setImageColor(color: .black)
    cell.lblTitle.textColor = .black

    animateCellSelection(cell)
}

private func configureDeselectedCell(_ cell: CustomTabBarCell) {
    cell.lblTitle.text = "test"
    cell.imgIcon.setImageColor(color: .red)
    cell.lblTitle.textColor = .red
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
