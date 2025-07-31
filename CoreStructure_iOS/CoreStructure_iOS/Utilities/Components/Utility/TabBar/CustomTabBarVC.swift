
import UIKit

class CustomTabBarVC: UITabBarController, UIGestureRecognizerDelegate {
    
    // properties for tabBar view controller
    private let secondVC = HomeABAVC()
    private let firstVC = DemoFeatureVC()
    private let googleMapsVC = GoogleMapsViewController()
    private let fourtVC = GoogleMapsViewController()
    private let fiveVC = GoogleMapsViewController()
    
    // properties for animation tabBar custom
    private var previousOffsetY: CGFloat = 0
    private var isScrollingDown : Bool = false
    private var lastContentOffset: CGFloat = 0
    
    // data for tabbar
    private var titleNavigationBar: [TitleIconModel] = [
        TitleIconModel(name: "Home", iconName: ""),
        TitleIconModel(name: "News", iconName: ""),
        TitleIconModel(name: "BVM VIP", iconName: ""),
        TitleIconModel(name: "Station", iconName: ""),
        TitleIconModel(name: "More", iconName: "")
    ]
    
    
    private lazy var tabBarView: TabBarView = {
        let tabBarView = TabBarView()
        tabBarView.backgroundColor = .mainTabBarColor
        tabBarView.dataList = titleNavigationBar
        tabBarView.indexSelected = 1
        
        tabBarView.indexDidChange = { [weak self] index in
            self?.selectedIndex = index
            self?.setupNavigationBar(index: index)
        }
        
        return tabBarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupConstraint()
        setupNavigationBar()
        handleScrollingTabBar()
    }
}

extension CustomTabBarVC{
    
    private func setupNavigationBar(index: Int = 0){
        title = titleNavigationBar[index].name
    }
    
    private func setupViewControllers(){
        tabBar.isHidden = true
        view.backgroundColor = .mainBGColor
        viewControllers = [secondVC, firstVC, googleMapsVC, fourtVC, fiveVC]
    }
    
    private func setupConstraint(){
        
        view.addSubview(tabBarView)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            tabBarView.heightAnchor.constraint(equalToConstant: UIDevice.isDeviceHasSafeArea() ? 90 : 60),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tabBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
    }
}

// MARK: - Animation TabBar Scrolling
extension CustomTabBarVC {
    
    private func handleScrollingTabBar() {
        firstVC.didScrollView = { [weak self] scrollView in
            DispatchQueue.main.async {
                self?.handleScrolling(for: scrollView)
            }
        }
        
        secondVC.didScrollView = { [weak self] scrollView in
            DispatchQueue.main.async {
                self?.handleScrolling(for: scrollView)
            }
        }
    }

    private func handleScrolling(for scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let isScrollingDown = currentOffsetY > previousOffsetY
        previousOffsetY = currentOffsetY

        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        let contentOffsetY = scrollView.contentOffset.y

        updateTabBarPosition(
            offsetY: currentOffsetY,
            contentHeight: contentHeight,
            scrollViewHeight: scrollViewHeight,
            contentOffsetY: contentOffsetY,
            isScrollingDown: isScrollingDown
        )
    }

    private func updateTabBarPosition(offsetY: CGFloat,
                                      contentHeight: CGFloat,
                                      scrollViewHeight: CGFloat,
                                      contentOffsetY: CGFloat,
                                      isScrollingDown: Bool) {
        
        let hideThreshold: CGFloat = 50
        let maxOffset: CGFloat = 90
        let atBottom = contentHeight - scrollViewHeight - contentOffsetY <= 0
        
        if isScrollingDown && offsetY > hideThreshold && !atBottom {
            // Hide tab bar
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                self.tabBarView.transform = CGAffineTransform(translationX: 0, y: maxOffset)
            }
        } else if !isScrollingDown && !atBottom {
            // Show tab bar
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                self.tabBarView.transform = .identity
            }
        }
        
        lastContentOffset = offsetY
    }
}


// MARK: - addShape Collection
extension CustomTabBarVC{
    
    
    // MARK: If you to add shap you need add it on viewDidAppear
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        addShape(tabBarColor: .orange)
    //    }
    
    private func addShape(tabBarColor: UIColor) {
        
        tabBarView.backgroundColor = .clear
        tabBarView.collactionView.backgroundColor = .clear
        
        let shapeLayerTab = CAShapeLayer()
        shapeLayerTab.path = createPath()
        shapeLayerTab.fillColor = tabBarColor.cgColor
        shapeLayerTab.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayerTab.shadowOffset = CGSize(width: 0, height: 3)
        shapeLayerTab.shadowRadius = 10
        shapeLayerTab.shadowColor = UIColor.clear.cgColor
        shapeLayerTab.shadowOpacity = 0.3
        tabBarView.layer.insertSublayer(shapeLayerTab, at: 0)
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
        let centerWidth = tabBarView.frame.width / 2
        
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
        path.addLine(to: CGPoint(x: tabBarView.frame.width, y: 0))
        
        // Add a line to the bottom-right corner of the collection view
        path.addLine(to: CGPoint(x: tabBarView.frame.width, y: tabBarView.frame.height))
        
        // Add a line to the bottom-left corner of the collection view
        path.addLine(to: CGPoint(x: 0, y: tabBarView.frame.height))
        
        // Close the path to complete the shape
        path.close()
        
        // Return the created CGPath
        return path.cgPath
    }
}


//extension CustomTabBarVC{
//
//    private func handleScrollingTabBar(){
//        firstVC.didScrollView = { [weak self] scrollView  in
//            guard let self else{ return }
//
//            let currentOffsetY = scrollView.contentOffset.y
//            isScrollingDown = currentOffsetY > previousOffsetY
//            previousOffsetY = currentOffsetY
//
//            let contentHeight = secondVC.scrollView.contentSize.height
//            let scrollViewHeight = secondVC.scrollView.frame.height
//            let contentOffsetY = secondVC.scrollView.contentOffset.y
//
//            self.updateCollectionViewPosition(offsetY: currentOffsetY,
//                                              contentHeight: contentHeight,
//                                              scrollViewHeight: scrollViewHeight,
//                                              contentOffsetY: contentOffsetY)
//        }
//
//
//        secondVC.didScrollView = { [weak self] scrollView  in
//            guard let self else{ return }
//
//            let currentOffsetY = scrollView.contentOffset.y
//            isScrollingDown = currentOffsetY > previousOffsetY
//            previousOffsetY = currentOffsetY
//
//            let contentHeight = secondVC.scrollView.contentSize.height
//            let scrollViewHeight = secondVC.scrollView.frame.height
//            let contentOffsetY = secondVC.scrollView.contentOffset.y
//
//            self.updateCollectionViewPosition(offsetY: currentOffsetY,
//                                              contentHeight: contentHeight,
//                                              scrollViewHeight: scrollViewHeight,
//                                              contentOffsetY: contentOffsetY)
//        }
//    }
//
//    private func updateCollectionViewPosition(offsetY: CGFloat,
//                                              contentHeight: CGFloat,
//                                              scrollViewHeight: CGFloat,
//                                              contentOffsetY: CGFloat) {
//        //MARK: - animation TabBar like ACLEDA TabBar
//        let hideThreshold: CGFloat = 50  // Adjust when the collection view should start hiding
//        let maxOffset: CGFloat = 90      // Height of the collection view
//
//
//        // Check if the scroll view is at the bottom (end) to prevent scrolling behavior
//        let atBottom = contentHeight - scrollViewHeight - contentOffsetY <= 0
//
//        if offsetY > lastContentOffset, offsetY > hideThreshold, !atBottom {
//            // Scroll down -> Hide collection view (if not at bottom)
//            UIView.animate(withDuration: 0.2) {
//                self.tabBarView.transform = CGAffineTransform(translationX: 0, y: maxOffset)
//            }
//        } else if offsetY < lastContentOffset, !atBottom {
//            // Scroll up -> Show collection view (if not at bottom)
//            UIView.animate(withDuration: 0.2) {
//                self.tabBarView.transform = .identity
//            }
//        }
//
//        lastContentOffset = offsetY
//    }
//
//}
