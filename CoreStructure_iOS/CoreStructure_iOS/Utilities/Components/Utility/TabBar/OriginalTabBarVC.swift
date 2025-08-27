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
        
        self.selectedIndex = 0
        self.delegate = self
        
        setupViewControllers()

        configureTabBarAppearance()
    }
    
    private func setupViewControllers() {
        // Create instances of view controllers
        let firstVC = DemoFeatureVC()
        let secondVC = UIViewController()
        let threeVC = UIViewController()
        let fourtVC = UIViewController()
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
        appearance.backgroundColor = .mainBlueColor // Background color of the tab bar
        appearance.stackedLayoutAppearance.normal.iconColor = .gray // Unselected icon color
        appearance.stackedLayoutAppearance.selected.iconColor = .white // Selected icon color
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray] // Unselected title color
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Selected title color
        
        // Assign the appearance to the tab bar
        tabBar.backgroundColor = .mainBlueColor // Background color of the tab bar
        tabBar.standardAppearance = appearance
        
        
        
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
        
        // Update the previous index
        previousIndex = selectedIndex
        
    }
    
}

