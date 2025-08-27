//
//  BaseUIPageViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/11/24.
//

import UIKit

class BaseUIPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var currentIndex = 0
    private var pages = [UIViewController]()
    
    func setupPageViewController(pages: [UIViewController],
                                 currentIndex: Int,
                                 in container: UIView,
                                 from parent: UIViewController) {
        self.pages = pages
        self.currentIndex = currentIndex
        
        parent.addChild(self)
        container.addSubview(view)
        self.didMove(toParent: parent)
        
        setViewControllers([pages[currentIndex]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
    }
    
    // ✅ Custom initializer with desired transition style
    init() {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - DataSource
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        currentIndex = index
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        currentIndex = index
        return pages[index + 1]
    }

    
    private var isAnimatingPageTransition = false

    func goToPageViewController(index: Int) {
        guard !isAnimatingPageTransition else { return }
        guard index >= 0 && index < pages.count else { return }
        
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        
        isAnimatingPageTransition = true
        setViewControllers([pages[index]], direction: direction, animated: true) { [weak self] completed in
            self?.isAnimatingPageTransition = false
            if completed {
                self?.currentIndex = index
            }
        }
    }
}


class PageVC: BaseInteractionViewController {
    
    let pageVC = BaseUIPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainColor
        title = "Page ViewController"
        
        setupPageViewController()
        setupButtons()
    }
    
    func setupPageViewController() {
        
        let page1 = UIViewController()
        page1.view.backgroundColor = .white
        let page2 = UIViewController()
        page2.view.backgroundColor = .cyan
        let page3 = UIViewController()
        page3.view.backgroundColor = .gray
        
        pageVC.setupPageViewController(
            pages: [page1, page2, page3],
            currentIndex: 1,
            in: view,
            from: self
        )

    }
    
    func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        let buttonTitles = ["Page 1", "Page 2", "Page 3"]
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(pageButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 100),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -100),
        ])
    }
    
    @objc func pageButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        
        if pageVC.currentIndex != index{
            pageVC.goToPageViewController(index: index)
        }
    }
}

