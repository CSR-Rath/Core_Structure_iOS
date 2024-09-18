//
//  OriginalTabBarVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit

class OriginalTabBarVC: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        
        // Set the default selected index
        self.selectedIndex = 0
        self.delegate = self
        
        
        // Customize tab bar appearance
        configureTabBarAppearance()
    }
    
    private func setupViewControllers() {
        // Create instances of view controllers
        let firstVC = FirstViewController()
        let secondVC = SecondViewController()
        let threeVC = ThreeViewController()
        let fourtVC = FourViewController()
        
        
        // Set titles and tab bar items for each view controller
        firstVC.title = "Home"
        firstVC.tabBarItem = UITabBarItem(title: "Home",
                                            image: UIImage(systemName: "1.circle"),
                                            tag: 0)
        
        secondVC.title = "News"
        secondVC.tabBarItem = UITabBarItem(title: "News",
                                             image: UIImage(systemName: "2.circle"),
                                             tag: 1)
        
        threeVC.title = "Station"
        threeVC.tabBarItem = UITabBarItem(title: "Station",
                                            image: UIImage(systemName: "3.circle"),
                                            tag: 2)
        
        fourtVC.title = "More"
        fourtVC.tabBarItem = UITabBarItem(title: "More",
                                            image: UIImage(systemName: "4.circle"),
                                            tag: 3)
        
        // Set the view controllers for the tab bar
        viewControllers = [firstVC, secondVC, threeVC, fourtVC]
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
//            item.image = item.selectedImage?.withRenderingMode(.alwaysOriginal)
        }, completion: nil)
    }
    
    
    
    
    
    
    
    // UITabBarControllerDelegate method
//       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//           guard let tabBarItems = tabBar.items else { return }
//
//           // Get the index of the selected tab
//           let selectedIndex = tabBarController.selectedIndex
//           
//           // Animate the tab bar item selection
//           let item = tabBarItems[selectedIndex]
//           
//           // Scale animation for the tab bar item
//           UIView.animate(withDuration: 0.3, animations: {
//               item.image = item.selectedImage?.withRenderingMode(.alwaysOriginal)
//               // Optionally, you can add a scale effect for the icon
//               if let iconView = self.tabBar.subviews[selectedIndex + 1] as? UIView { // +1 to skip the background view
//                   iconView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//               }
//           }, completion: { _ in
//               UIView.animate(withDuration: 0.3) {
//                   if let iconView = self.tabBar.subviews[selectedIndex + 1] as? UIView {
//                       iconView.transform = CGAffineTransform.identity
//                   }
//               }
//           })
//       }
    
}


