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
    
    private let firstVC = DemoFeatureVC()
    private let secondVC = UIViewController()
    private let threeVC = UIViewController()
    private let fourtVC = UIViewController()
    
    private let dataList : [TitleIconModel] = [
        TitleIconModel(name: "VC", iconName: ""),
        TitleIconModel(name: "Package", iconName: ""),
        TitleIconModel(name: "Padding", iconName: ""),
        TitleIconModel(name: "Find", iconName: ""),
    ]
    
    private var lastContentOffset: CGFloat = 0

    var indexSelected: Int = 0{
        didSet{
            print("indexSelected ==>\(indexSelected)")
            // Update the title based on the selected index
            title = viewControllers?[indexSelected].title
            selectedIndex = indexSelected
            collactionView.reloadData()
        }
    }
    
    lazy var collactionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .mainBlueColor
        collection.delegate = self
        collection.dataSource = self
        collection.register(CustomTabBarCell.self, forCellWithReuseIdentifier: CustomTabBarCell.identifier)
        return collection
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false // disable
        self.tabBar.isHidden = true
    }
    

    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true // enable
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewControllers = [firstVC, secondVC, threeVC, fourtVC]
        title = viewControllers?[indexSelected].title?.localizeString()
        
        firstVC.didScrollView = { offsetY, isScrollDown in
            self.updateCollectionViewPosition(offsetY: offsetY)
        }
        
    }
    
    

    private func updateCollectionViewPosition(offsetY: CGFloat) {
        //MARK: - animation TabBar like ACLEDA TabBar
        let hideThreshold: CGFloat = 50  // Adjust when the collection view should start hiding
        let maxOffset: CGFloat = 85      // Height of the collection view
        let contentHeight = firstVC.tableView.contentSize.height
        let scrollViewHeight = firstVC.tableView.frame.height
        let contentOffsetY = firstVC.tableView.contentOffset.y
        
        // Check if the scroll view is at the bottom (end) to prevent scrolling behavior
        let atBottom = contentHeight - scrollViewHeight - contentOffsetY <= 0
        
        if offsetY > lastContentOffset, offsetY > hideThreshold, !atBottom {
            // Scroll down -> Hide collection view (if not at bottom)
            UIView.animate(withDuration: 0.2) {
                self.collactionView.transform = CGAffineTransform(translationX: 0, y: maxOffset)
            }
        } else if offsetY < lastContentOffset, !atBottom {
            // Scroll up -> Show collection view (if not at bottom)
            UIView.animate(withDuration: 0.2) {
                self.collactionView.transform = .identity
            }
        }
        
        lastContentOffset = offsetY
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraintAndSetupController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let layout = collactionView.collectionViewLayout as? UICollectionViewFlowLayout { // handle cell items
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
    
        view.addSubview(collactionView)
        NSLayoutConstraint.activate([
        
            collactionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collactionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collactionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collactionView.heightAnchor.constraint(equalToConstant: 85),
        
        ])
    }
    
    private func clearAppearanceTabBar(){
        // MARK: - Because using  custom tabbar
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground() // Makes it clear
        appearance.backgroundColor = UIColor.clear // Ensure no color is applied
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // Customize tab bar item title appearance
         let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.clear,
         ]
         
         appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
         appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes
         

        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
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
        }
    }
}

//MARK: Handle Cell conditions

private func configureSelectedCell(_ cell: CustomTabBarCell) {
    cell.imgIcon.setImageColor(color: .white)
    cell.lblTitle.textColor = .white
    cell.lblTitle.fontBold(13)
    animateCellSelection(cell)
}

private func configureDeselectedCell(_ cell: CustomTabBarCell) {
    cell.imgIcon.setImageColor(color: .gray)
    cell.lblTitle.textColor = .gray
    cell.lblTitle.fontRegular(13)
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
