//
//  OriginalTabBarVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit

class OriginalTabBarVC: UITabBarController,UITabBarControllerDelegate {
    private var previousIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
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
        
        
        // Animate the transition
              if previousIndex != selectedIndex {
                  let transition = CATransition()
                  transition.duration = 0.15
                  transition.type = selectedIndex > previousIndex ? .moveIn : .push
                  transition.subtype = selectedIndex > previousIndex ? .fromRight : .fromLeft
                  
                  viewController.view.layer.add(transition, forKey: kCATransition)
              }
              
              // Update the previous index
              previousIndex = selectedIndex
        
        
    }
        
}


