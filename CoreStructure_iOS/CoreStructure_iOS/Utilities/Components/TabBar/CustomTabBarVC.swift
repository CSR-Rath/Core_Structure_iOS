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
    private let fiveVC = UIViewController()
    private var lastContentOffset: CGFloat = 0
    private let dataList : [TitleIconModel] = [
        TitleIconModel(name: "VC", iconName: ""),
        TitleIconModel(name: "Package", iconName: ""),
        TitleIconModel(name: "", iconName: ""),
        TitleIconModel(name: "Padding", iconName: ""),
        TitleIconModel(name: "Find", iconName: ""),
    ]
    
    private let titleList: [String] = ["Demo Feature", "News", "Google Maps","More"]

    private var indexSelected: Int = 0{
        
        didSet{
            title = titleList[indexSelected]
            selectedIndex = indexSelected
            collactionView.reloadData()
            validationButtonRight()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleList[indexSelected]
        view.backgroundColor = .white
        setupConstraintAndSetupController()
        validationButtonRight()
        viewControllers = [firstVC, secondVC, threeVC, fourtVC, fiveVC]
        
        
        firstVC.didScrollView = { offsetY, isScrollDown in
            self.updateCollectionViewPosition(offsetY: offsetY)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false // disable
        self.tabBar.isHidden = true
        self.addShape()  // Call to add the custom shape
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true // enable
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        if let layout = collactionView.collectionViewLayout as? UICollectionViewFlowLayout { // handle cell items

            let spac: CGFloat = 10
            let spacing = CGFloat(dataList.count-1) * spac
            let itemWidth = (view.bounds.width-spacing) / CGFloat(dataList.count)
            let itemHeight = collactionView.frame.height
            
            layout.minimumLineSpacing = spac
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
    @objc private func rightButtonTapped() {
        print("Right button tapped FaceID")
    }
    
}

extension CustomTabBarVC{
    
    private func validationButtonRight(){
        
        let rightButton = UIBarButtonItem(image: .icFaceID,
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        
        if #available(iOS 16.0, *) {
            navigationItem.rightBarButtonItem?.isHidden = indexSelected == 0 ? false : true
        } else {
            if indexSelected != 0{
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    private func setupConstraintAndSetupController(){
    
        view.addSubview(collactionView)
        NSLayoutConstraint.activate([
        
            collactionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collactionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collactionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collactionView.heightAnchor.constraint(equalToConstant: 85),
        
        ])
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
    
}



// MARK: - addShape Collection
extension CustomTabBarVC{
    
    private func addShape() {

        let shapeLayerTab = CAShapeLayer()
        shapeLayerTab.path = createPath()
        shapeLayerTab.fillColor = UIColor.mainBlueColor.cgColor
        shapeLayerTab.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayerTab.shadowOffset = CGSize(width: 0, height: 3)
        shapeLayerTab.shadowRadius = 10
        shapeLayerTab.shadowColor = UIColor.clear.cgColor
        shapeLayerTab.shadowOpacity = 0.3
        collactionView.layer.insertSublayer(shapeLayerTab, at: 0)
    }
    
    private func createPath() -> CGPath {
        // Define constants to control the size and appearance of the shape
        let height: CGFloat = 50  // Height for the bottom curve
        let heightTwo: CGFloat = 50  // Width size at the top (defines the "trough")
        
        let topZise: CGFloat = 35  // Controls the sharpness of the curve at the top
        let bottomSize: CGFloat = 50  // Controls the size of the bottom curve
        let cornerTop: CGFloat = 1.2  // A factor to adjust the sharpness of the top corners
        
        // Create a UIBezierPath to define the custom shape
        let path = UIBezierPath()
        
        // Center of the collection view (for centering the shape horizontally)
        let centerWidth = collactionView.frame.width / 2
        
        // Move the path starting point to the top-left corner of the collection view
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Add a line from the starting point to a point on the left side of the "trough"
        path.addLine(to: CGPoint(x: (centerWidth - heightTwo * cornerTop), y: 0))
        
        // Add the first curve from the left side of the trough to the center
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - topZise), y: 0),
                      controlPoint2: CGPoint(x: centerWidth - bottomSize, y: height))
        
        // Add the second curve from the center to the right side of the trough
        path.addCurve(to: CGPoint(x: (centerWidth + heightTwo * cornerTop), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + bottomSize, y: height),
                      controlPoint2: CGPoint(x: (centerWidth + topZise), y: 0))
        
        // Add a line to the top-right corner of the collection view
        path.addLine(to: CGPoint(x: collactionView.frame.width, y: 0))
        
        // Add a line to the bottom-right corner of the collection view
        path.addLine(to: CGPoint(x: collactionView.frame.width, y: collactionView.frame.height))
        
        // Add a line to the bottom-left corner of the collection view
        path.addLine(to: CGPoint(x: 0, y: collactionView.frame.height))
        
        // Close the path to complete the shape
        path.close()
        
        // Return the created CGPath
        return path.cgPath
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
        
        if indexPath.item != 2{
            cell.imgIcon.image = UIImage(systemName: "swift" )
        }
        
        if indexSelected  == indexPath.item {
            configureSelectedCell(cell)
        } else {
            configureDeselectedCell(cell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexSelected != indexPath.item && indexPath.item != 2 {
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
