//
//  PageViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/11/24.
//

import UIKit

class PageViewController: UIViewController {
    
    var didChangeIndex: ((_ index: Int)->())?
    var willChangeIndex: ((_ index: Int)->())?
    var controllers = [UIViewController]()
    
    
    private var pageController =  UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal,options: nil)
    
    private var index: Int = 0
    var currentPage: Int = 0{
        didSet{
            DispatchQueue.main.async {
                let direction: UIPageViewController.NavigationDirection = (self.index < self.currentPage) ? .forward : .reverse
                
                if self.currentPage >= 0 && self.currentPage < self.controllers.count {
                    self.pageController.setViewControllers(
                        [self.controllers[self.currentPage]],
                        direction: direction,
                        animated: true,
                        completion: nil
                    )
                    self.index = self.currentPage
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPageController()
    }

    private func setupPageController(){
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.backgroundColor = .white
        pageController.view.frame = view.bounds
    }
    
}



//MARK: Handle pageController
extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
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
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: currentViewController) {
                didChangeIndex?(index)
                currentPage = index
            }
        }
    }
}

