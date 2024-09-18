//
//  PagViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import UIKit


class PageViewController: UIViewController {
    
    private var currentPage = 0
    private var isTransitionInProgress = false
    private var collectionView: UICollectionView!
    private var pageController =  UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal,options: nil)
    
    //MARK:  Set select items collection view first
    var controllers = [UIViewController]() // Create empty ViewController
    {
        didSet{
            DispatchQueue.main.async { [self] in
                collectionView.reloadData()
                if arrayTitleName.count > 0{
                    collectionView.selectItem(at: IndexPath(item: currentPage, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                }
            }
        }
    }
    
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
        //        setupTitle()
        //        setupPageController()
    }
    
    
    /*private*/ func setupTitle(){
        
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
    
    /*private*/ func setupPageController(){
        addChild(pageController)
        view.addSubview(pageController.view)
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

extension PageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTitleName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
        cell.lblTitle.text  = arrayTitleName[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        //MARK: Protect , when didSelectItemAt fast
        if index != currentPage && index < controllers.count && !isTransitionInProgress {
            //scroll items to center
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            //set scroll pagViewContoller
            let direction: UIPageViewController.NavigationDirection = index > currentPage ? .forward : .reverse
            isTransitionInProgress = true
            pageController.setViewControllers([controllers[index]], direction: direction, animated: true) { [weak self] (completed) in
                if completed {
                    self?.currentPage = index
                }
                self?.isTransitionInProgress = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthLabel =  arrayTitleName[indexPath.item]
        //dynamic width by text
        let font =  UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let Label1 =  arrayTitleName[0]
        let Label2 =  arrayTitleName[1]
        let Label3 =  arrayTitleName[2]
        let Label4 =  arrayTitleName[3]
        
        let width1 = calculateLabelWidth(text: Label1, font: font)
        let width2 = calculateLabelWidth(text: Label2, font: font)
        let width3 = calculateLabelWidth(text: Label3, font: font)
        let width4 = calculateLabelWidth(text: Label4, font: font)
        
        //MARK: Dynamic all screen
        let screen =  ((UIScreen.main.bounds.width-60)-width1-width2-width3-width4)/4
        let width = calculateLabelWidth(text: widthLabel, font: font) + screen
        return CGSize(width: width, height: 36)
    }
    
    //MARK: calculate text label width
    private func calculateLabelWidth(text: String, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.frame.width
    }
    
}

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
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                lblTitle.textColor = .white
                backgroundColor = .orange
            }
            else{
                lblTitle.textColor = .white
                backgroundColor = .gray
            }
        }
    }
}
