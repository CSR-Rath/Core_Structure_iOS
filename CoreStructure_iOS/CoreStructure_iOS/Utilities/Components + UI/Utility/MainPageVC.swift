//
//  MainPageVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 14/10/24.
//

import UIKit

class MainPageVC: UIViewController {
    // Create empty ViewController
    var controllers = [UIViewController]()
    
    private var index: Int = 0
    private var pageController =  UIPageViewController(transitionStyle: .scroll,
                                                       navigationOrientation: .horizontal,options: nil)
    
    var changeControllerIndex: Int = 0{
        didSet{
            DispatchQueue.main.async { [self] in
                
                let direction: UIPageViewController.NavigationDirection = changeControllerIndex > index ? .forward : .reverse
                
                pageController.setViewControllers([controllers[changeControllerIndex]],
                                                  direction: direction,
                                                  animated: true,
                                                  completion: nil)
                index = changeControllerIndex
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupPageController()
    }
    
    private func setupPageController() {
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.pageController.view.backgroundColor = .clear
        self.pageController.view.frame = CGRect(x: 0,y: 0,
                                                width: self.view.frame.width,
                                                height: self.view.frame.height)
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
        self.pageController.setViewControllers([controllers[index]], direction: .forward, animated: true, completion: nil)
    }
    
    
    // Add view controllers to the contentViewController array
    func addContentViewController(viewController: UIViewController) {
        controllers.append(viewController)
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
extension MainPageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
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
        
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: currentViewController) {
                
                changeControllerIndex = index
            }
        }
    }
}

