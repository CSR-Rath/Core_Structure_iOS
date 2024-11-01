//
//  CustomTabBarVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit


struct TitleIconModel{
    let name: String
    let iconName: String
}


class CustomTabBarVC: UITabBarController {
    
    private let dataList : [TitleIconModel] = [
    
        TitleIconModel(name: "VC", iconName: ""),
        TitleIconModel(name: "Package", iconName: ""),
        TitleIconModel(name: "Padding", iconName: ""),
        TitleIconModel(name: "Find", iconName: ""),
    
    ]

    var indexSelected: Int = 0{
        didSet{
            self.selectedIndex = indexSelected
            collactionView.reloadData()
            // Update the title based on the selected index
               self.title = viewControllers?[indexSelected].title
        }
    }
    
    
    
    lazy var collactionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
//        collection.layer.borderWidth = 0.16
//        collection.layer.borderColor = UIColor.black.cgColor
        collection.backgroundColor = .lightGray
        collection.delegate = self
        collection.dataSource = self
        collection.register(CustomTabBarCell.self, forCellWithReuseIdentifier: CustomTabBarCell.identifier)
        return collection
    }()
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        tabBar.isHidden = true
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
        
        let firstVC = DemoFeatureVC()
        firstVC.title = "Demo Feature"
        
        let secondVC = SecondViewController()
        secondVC.title = "Demo 2"
        
        let threeVC = ThreeViewController()
        threeVC.title = "Hello 3"
        
        let fourtVC = FourViewController()
        fourtVC.title = "Hello 4"
        
        viewControllers = [firstVC, secondVC, threeVC, fourtVC]
        self.title = viewControllers?[indexSelected].title
        
        view.addSubview(collactionView)
        NSLayoutConstraint.activate([
        
            collactionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collactionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collactionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collactionView.heightAnchor.constraint(equalToConstant: 85),
        
        ])
        
        print( "statusBarHeight ==> ", ConstantsHeight.statusBarHeight,
               "\navigationBarHeight ==> " , ConstantsHeight.navigationBarHeight,
               "\navailableHeight ==> ", ConstantsHeight.availableHeight,
               "\nConstantsHeight.safeAreaTop ==> ", ConstantsHeight.safeAreaTop,
               "\nConstantsHeight.safeAreaBottom ==> ", ConstantsHeight.safeAreaBottom
        )
        
    }
}




//MARK: Delegate and Datasource
extension CustomTabBarVC:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomTabBarCell.identifier, for: indexPath) as! CustomTabBarCell
        
        cell.lblTitle.text = dataList[indexPath.item].name
        
        
        UIView.animate(withDuration: 0.3, animations: {
//            cell.imgIcon.image = item.selectedImage?.withTintColor(.white) // Change color if needed
//            item.image = item.selectedImage?.withRenderingMode(.alwaysOriginal)
        }, completion: nil)
        
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
    
    cell.imgIcon.setImageColor(color: .black)
    cell.lblTitle.textColor = .black

    animateCellSelection(cell)
}

private func configureDeselectedCell(_ cell: CustomTabBarCell) {
   
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
