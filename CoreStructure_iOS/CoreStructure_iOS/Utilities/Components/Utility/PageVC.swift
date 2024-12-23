//
//  PagViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import UIKit

class PageVC: UIViewController {
    
    private var collectionView: UICollectionView!
     var pageController =  UIPageViewController(transitionStyle: .scroll,
                                                       navigationOrientation: .horizontal,options: nil)
    private var lineViewTop: UIView? = nil
    private var istransitionCompleted: Bool = true
    
    
    private var currentPage = 0{
        didSet{
            DispatchQueue.main.async { [self] in
                collectionView.reloadData()
            }
        }
    }
    
    //MARK:  Set select items collection view first
    var controllers = [UIViewController]() // Create empty ViewController
    
    //MARK: Set select pagViewController first
    var arrayTitleName = [String]()
    {
        didSet{
            DispatchQueue.main.async { [self] in
                if controllers.count > 0{
                    pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTitle()
        setupLineView()
        setupPageController()
        
        arrayTitleName = ["A", "B", "C"]
        
        arrayTitleName.forEach({  item in
        
            let vc = UIViewController()
            vc.view.backgroundColor = randomColor()
            controllers.append(vc)
            
        })
        
    }
    
    func setupTitle(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.identifier)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15),
            collectionView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func setupLineView(){
        
        lineViewTop = UIView()
        lineViewTop?.translatesAutoresizingMaskIntoConstraints = false
        lineViewTop?.backgroundColor = .gray
        
        guard let lineViewTop =  lineViewTop else{
            return
        }
        
        view.addSubview(lineViewTop )
        NSLayoutConstraint.activate([
            lineViewTop.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            lineViewTop.leftAnchor.constraint(equalTo: view.leftAnchor),
            lineViewTop.rightAnchor.constraint(equalTo: view.rightAnchor),
            lineViewTop.heightAnchor.constraint(equalToConstant: 0.3),
            
        ])
        
    }
    
    func setupPageController(){
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 15),
            pageController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            pageController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    //MARK: Rendom CGFloat
    private func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    //MARK: Rendom Color
    func randomColor() -> UIColor {
        return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
    }
}



//MARK: Handle pageController
extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        
        // Check if the next index is within bounds
        guard nextIndex < controllers.count else {
            return nil
        }
        
        return controllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        
        //        guard let pendingViewController = pendingViewControllers.first,
        //              let index = contentViewController.firstIndex(of: pendingViewController) else {
        //            return
        //        }
        //
        //        pendingPage = index
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: currentViewController) {
                
                currentPage = index
            }
        }
    }
}


//MARK: Handle collectionView
extension PageVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTitleName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
        cell.lblTitle.text  = arrayTitleName[indexPath.item]
        
        if currentPage == indexPath.item {
            cell.lblTitle.textColor = .white
            cell.backgroundColor = .orange
            
            // Animate the selection
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) // Scale up
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.transform = CGAffineTransform.identity // Scale back
                }
            }
        }
        else{
            cell.lblTitle.textColor = .red
            cell.backgroundColor = .gray
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if istransitionCompleted && currentPage != indexPath.item {
            istransitionCompleted = false
            let index = indexPath.item
            let direction: UIPageViewController.NavigationDirection = index > currentPage ? .forward : .reverse
            // Set the view controller for the page controller
            pageController.setViewControllers([controllers[index]], direction: direction, animated: true)
            { [self] status in
                istransitionCompleted = status
               
                print("status or istransitionCompleted == > " ,status)
            }
//        }else{
//            istransitionCompleted = true
//        }
        self.currentPage = indexPath.item // Update current page after transition

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthLabel =  arrayTitleName[indexPath.item]
        //dynamic width by text
        let font =   UIFont.systemFont(ofSize: 20, weight: .bold)
        
        var widthText: CGFloat = 0
        
        arrayTitleName.forEach { item in
            widthText += view.calculateLabelWidth(text: item, font: font)
        }
        
        //MARK: Dynamic all screen
        let screen =  ((UIScreen.main.bounds.width-60)-widthText) / CGFloat(arrayTitleName.count)
        let width = view.calculateLabelWidth(text: widthLabel, font: font) + screen
        return CGSize(width: width, height: 36)
    }
}



//MARK: Cell
class TitleCell: UICollectionViewCell {
    
    static let identifier = "TitleCell"
    
    lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.fontBold(14)
        return label
    }()
    
    private let viewLine: UIView = {
        let viewLine = UIView()
        viewLine.translatesAutoresizingMaskIntoConstraints = false
        viewLine.backgroundColor = .clear
        return viewLine
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.layer.cornerRadius = 8
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView(){
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lblTitle)
        NSLayoutConstraint.activate([
            lblTitle.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
            lblTitle.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
            lblTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
//    override var isSelected: Bool{
//        didSet{
//            if isSelected{
//                lblTitle.textColor = .white
//                backgroundColor = .orange
//            }
//            else{
//                lblTitle.textColor = .white
//                backgroundColor = .gray
//            }
//        }
//    }
}
