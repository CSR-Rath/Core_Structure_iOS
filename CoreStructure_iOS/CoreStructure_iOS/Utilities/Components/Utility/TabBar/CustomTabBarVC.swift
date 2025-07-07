import UIKit

let tabBarHeight: CGFloat = UIDevice.isDeviceHasSafeArea() ? 90 : 60

class CustomTabBarVC: UITabBarController, UIGestureRecognizerDelegate {
    
    private let firstVC = DemoFeatureVC()
    private let secondVC = UIViewController()
    private let googleMapsVC = GoogleMapsViewController()
    private let fourtVC = UIViewController()
    private let fiveVC = UIViewController()
   
    private var previousOffsetY: CGFloat = 0
    private var isScrollingDown : Bool = false
    private var lastContentOffset: CGFloat = 0
    
    
    var titleNavigationBar: [TitleIconModel] = [
        
        TitleIconModel(name: "Home", iconName: ""),
        TitleIconModel(name: "News", iconName: ""),
        TitleIconModel(name: "BVM VIP", iconName: ""),
        TitleIconModel(name: "Station", iconName: ""),
        TitleIconModel(name: "More", iconName: "")
    
    ]
    
    private lazy var tabBarView: TabBarView = {
        let tabBarView = TabBarView()
        tabBarView.backgroundColor = .orange
//        tabBarView.alpha = 0.3
        tabBarView.indexDidChange = { [weak self] index in
            self?.selectedIndex = index
            self?.setupNavigationBar(index: index)
        }
        tabBarView.dataList = titleNavigationBar
        return tabBarView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBarButtonItem(iconButton: .isEmpty)
        setupViewControllers()
        setupConstraintAndSetupController()
        setupNavigationBar()
    }
    
}

extension CustomTabBarVC{
    
    
    private func setupNavigationBar(index: Int = 0){
        title = titleNavigationBar[index].name
    }
    
    private func setupViewControllers(){
        
        tabBar.isHidden = true
        view.backgroundColor = .white
        viewControllers = [firstVC, secondVC, googleMapsVC, fourtVC, fiveVC]
        
        // Animation when scrolling
        firstVC.didScrollView = { [self] scrollView  in
            
            let currentOffsetY = scrollView.contentOffset.y
            isScrollingDown = currentOffsetY > previousOffsetY
            previousOffsetY = currentOffsetY
            
            self.updateCollectionViewPosition(offsetY: currentOffsetY)
        }
        
    }
    
    private func updateCollectionViewPosition(offsetY: CGFloat) {
        //MARK: - animation TabBar like ACLEDA TabBar
        let hideThreshold: CGFloat = 50  // Adjust when the collection view should start hiding
        let maxOffset: CGFloat = 90      // Height of the collection view
        let contentHeight = firstVC.tableView.contentSize.height
        let scrollViewHeight = firstVC.tableView.frame.height
        let contentOffsetY = firstVC.tableView.contentOffset.y
        
        // Check if the scroll view is at the bottom (end) to prevent scrolling behavior
        let atBottom = contentHeight - scrollViewHeight - contentOffsetY <= 0
        
        if offsetY > lastContentOffset, offsetY > hideThreshold, !atBottom {
            // Scroll down -> Hide collection view (if not at bottom)
            UIView.animate(withDuration: 0.2) {
                self.tabBarView.transform = CGAffineTransform(translationX: 0, y: maxOffset)
            }
        } else if offsetY < lastContentOffset, !atBottom {
            // Scroll up -> Show collection view (if not at bottom)
            UIView.animate(withDuration: 0.2) {
                self.tabBarView.transform = .identity
            }
        }
        
        lastContentOffset = offsetY
    }
    
    private func setupConstraintAndSetupController(){
        
        view.addSubview(tabBarView)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            tabBarView.heightAnchor.constraint(equalToConstant: tabBarHeight),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tabBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        
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

