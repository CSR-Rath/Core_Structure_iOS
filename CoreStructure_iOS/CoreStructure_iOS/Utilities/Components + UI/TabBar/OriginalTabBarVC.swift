//
//  OriginalTabBarVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit

class OriginalTabBarVC: UITabBarController,UITabBarControllerDelegate {
    private var previousIndex: Int = 0
    
//    private let shapeLayerTab = CAShapeLayer()
//    private var shapeLayer: CALayer?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupViewControllers()
        
        // Set the default selected index
        self.selectedIndex = 0
        self.delegate = self
        
        
        // Customize tab bar appearance
        configureTabBarAppearance()
//        addShape()
    }
    
    private func setupViewControllers() {
        // Create instances of view controllers
        let firstVC = DemoFeatureVC()
        let secondVC = SecondViewController()
        let threeVC = ThreeViewController()
        let fourtVC = FourViewController()
        let five = UIViewController()
        
        
        // Set titles and tab bar items for each view controller
        firstVC.title = "title"
        firstVC.tabBarItem = UITabBarItem(title: "Home",
                                            image: UIImage(systemName: "1.circle"),
                                            tag: 0)
        
        secondVC.title = "title"
        secondVC.tabBarItem = UITabBarItem(title: "News",
                                             image: UIImage(systemName: "2.circle"),
                                             tag: 1)
        
        threeVC.title = "title"
        threeVC.tabBarItem = UITabBarItem(title: "Station",
                                            image: UIImage(systemName: "3.circle"),
                                            tag: 2)
        
        fourtVC.title = "title"
        fourtVC.tabBarItem = UITabBarItem(title: "More",
                                            image: UIImage(systemName: "4.circle"),
                                            tag: 3)
        five.title = "title"
        five.tabBarItem = UITabBarItem(title: "More",
                                            image: UIImage(systemName: "5.circle"),
                                            tag: 4)
        
        // Set the view controllers for the tab bar
        viewControllers = [firstVC, secondVC, threeVC, fourtVC,five]
    }
    

    
    private func configureTabBarAppearance() {
        
        // Create a UITabBarAppearance instance
          let appearance = UITabBarAppearance()

          // Set up the colors for the appearance
          appearance.configureWithOpaqueBackground()
          appearance.backgroundColor = .orange // Background color of the tab bar
          appearance.stackedLayoutAppearance.normal.iconColor = .red // Unselected icon color
          appearance.stackedLayoutAppearance.selected.iconColor = .white // Selected icon color
          appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red] // Unselected title color
          appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Selected title color

          // Assign the appearance to the tab bar
        tabBar.backgroundColor = .orange // Background color of the tab bar
          tabBar.standardAppearance = appearance
//          tabBar.scrollEdgeAppearance = appearance // For scrollable content

       }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabBarItems = tabBar.items else { return }
        
        // Get the index of the selected tab
        let selectedIndex = tabBarController.selectedIndex
        
        // Animate the tab bar item selection
        let item = tabBarItems[selectedIndex]
        
        // Scale animation
        UIView.animate(withDuration: 0.3, animations: {
            item.image = item.selectedImage?.withTintColor(.white) // Change color if needed
        }, completion: nil)
        
        
        // Animate the transition
//              if previousIndex != selectedIndex {
//                  let transition = CATransition()
//                  transition.duration = 0.15
//                  transition.type = selectedIndex > previousIndex ? .moveIn : .push
//                  transition.subtype = selectedIndex > previousIndex ? .fromRight : .fromLeft
//                  
//                  viewController.view.layer.add(transition, forKey: kCATransition)
//              }
              
              // Update the previous index
              previousIndex = selectedIndex
        
        
    }
        
}




extension OriginalTabBarVC{
    
//    private func addShape() {
//        
//        shapeLayerTab.path = createPath()
//        shapeLayerTab.fillColor = UIColor.white.cgColor
//        shapeLayerTab.lineWidth = 1.0
//        
//        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
//        shapeLayerTab.shadowOffset = CGSize(width:0, height:5)
//        shapeLayerTab.shadowRadius = 10
//        shapeLayerTab.shadowColor = UIColor.gray.cgColor
//        shapeLayerTab.shadowOpacity = 0.8
//        
//        if let oldShapeLayer = self.shapeLayer {
//            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayerTab)
//        } else {
//            tabBar.layer.insertSublayer(shapeLayerTab, at: 0)
//        }
//        self.shapeLayer = shapeLayerTab
//    }
    
    //MARK : Draw UIView
//    private func createPath() -> CGPath {
//        
//        
//        let height: CGFloat = 50  //height down
//        let heightTwo: CGFloat =  50 // width size top
//        
//        let topZise: CGFloat = 35 //
//        let bottomSize: CGFloat = 50 //75 // size bottom
//        let cornerTop:CGFloat =  1.2// corner top
//        
//        let width = tabBar.bounds.width
//        let heightTabBar = tabBar.bounds.width
//        
//        let path = UIBezierPath()
//        let centerWidth = tabBar.bounds.width  / 2  //set at center
//        path.move(to: CGPoint(x: 0, y: 0)) // start top left
//        path.addLine(to: CGPoint(x: (centerWidth - heightTwo * cornerTop), y: 0)) // the beginning of the trough
//        
//        path.addCurve(to: CGPoint(x: centerWidth, y: height),
//                      controlPoint1: CGPoint(x: (centerWidth - topZise), y: 0), controlPoint2: CGPoint(x: centerWidth - bottomSize, y: height))
//        
//        path.addCurve(to: CGPoint(x: (centerWidth + heightTwo * cornerTop), y: 0),
//                      controlPoint1: CGPoint(x: centerWidth + bottomSize, y: height), controlPoint2: CGPoint(x: (centerWidth + topZise), y: 0))
//        
//        path.addLine(to: CGPoint(x: width, y: 0))
//        path.addLine(to: CGPoint(x: width, y: heightTabBar))
//        path.addLine(to: CGPoint(x: 0, y: heightTabBar))
//        path.close()
//        
//        return path.cgPath
//    }
    
}
