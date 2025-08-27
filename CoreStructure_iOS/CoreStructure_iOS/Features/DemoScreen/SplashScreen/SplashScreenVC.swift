//
//  SplashScreenVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/10/24.
//

import UIKit

var isFromAlertNotification: Bool = false

class SplashScreenVC: UIViewController {
    
    lazy var btnCustomTabBar: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Custom", for: .normal)
        btn.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    lazy var btnOriginal: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Original", for: .normal)
        btn.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    lazy var stackButton: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [btnCustomTabBar, btnOriginal])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Splash Screen"
        
        gotoTabBar(to: self)
    }
    
    
    private func setupConstraint() {
        view.addSubview(stackButton)
        
        NSLayoutConstraint.activate([
            stackButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }
    
    @objc private func didTappedButton(sender: UIButton) {
        let tabBar = CustomTabBarVC()
        self.pushVC(to: tabBar)
    }
}



@MainActor func gotoTabBar(to contoller: UIViewController, isChangRoot: Bool = false){
    
    print("contoller: \(contoller.title ?? "nil")")
    
    Loading.shared.showLoading()
    let viewModel = ViewModel()
    viewModel.asyncCall()
    viewModel.onDataUpdated = {
        Loading.shared.hideLoading()
        
        let tabBar = CustomTabBarVC()
        tabBar.posts = viewModel.posts ?? []
        tabBar.title =  contoller.title ?? "nil"

        if isChangRoot{
            SceneDelegate.shared.changeRootViewController(to: tabBar)
        }else{
            // Use like this it is working from click alert from push notification from app DidDisconnect
            contoller.navigationController?.pushViewController(tabBar, animated: false)
        }
    }
}



class RooViewController{
    
    @MainActor func gotoTabBar(to contoller: UIViewController, isChangRoot: Bool = false){
        
        print("contoller: \(contoller.title ?? "nil")")
        
        Loading.shared.showLoading()
        let viewModel = ViewModel()
        viewModel.asyncCall()
        viewModel.onDataUpdated = {
            Loading.shared.hideLoading()
            
            let tabBar = CustomTabBarVC()
            tabBar.posts = viewModel.posts ?? []
            tabBar.title =  contoller.title ?? "nil"
            SceneDelegate.shared.changeRootViewController(to: tabBar)

        }
    }

    
    
    
}




class PresentCustomBottomSheet: UIViewController {
    
    // MARK: - Properties
    
    private var maxDimmedAlpha: CGFloat = 0.6
    private let defaultHeight: CGFloat = 450
    private let dismissibleHeight: CGFloat = 450 - 150 // swipe dismiss
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 65
    private var currentContainerHeight: CGFloat = 450
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - UI Elements
    
    lazy var containerView: BlurredBackgroundView = {
        let view = BlurredBackgroundView()
        view.backgroundColor = .orange.withAlphaComponent(0.12)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(maxDimmedAlpha)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var btnCancel: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(animateDismissView), for: .touchUpInside)
        return btn
    }()
    
    lazy var topLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupConstraints()
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    // MARK: - Setup Methods
    
    private func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        containerView.addSubview(btnCancel)
        containerView.addSubview(topLineView)
        
        // Set static constraints for dimmedView
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // Set static constraints for containerView, btnCancel, and topLineView
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            btnCancel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            btnCancel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            btnCancel.heightAnchor.constraint(equalToConstant: 30),
            btnCancel.widthAnchor.constraint(equalToConstant: 30),
            
            topLineView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            topLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 5),
            topLineView.widthAnchor.constraint(equalToConstant: 36),
        ])
        
        // Set dynamic constraints for containerView
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    private func setupPanGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateDismissView))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        let pannedHeight = translation.y
        
        switch gesture.state {
            
        case .changed:
            
            if newHeight < maximumContainerHeight {
                if newHeight < defaultHeight {
                    let progress = pannedHeight / defaultHeight
                    maxDimmedAlpha = 0.6 * (1 - progress)
                    dimmedView.alpha = maxDimmedAlpha
                } else {
                    maxDimmedAlpha = 0.6
                }
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
            
        case .ended:
            
            if newHeight < dismissibleHeight {
                animateDismissView()
            } else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            } else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            } else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
            
        default:
            break
        }
        
    }
    
    // MARK: - Animation Methods
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    private func animatePresentContainer() { // show container
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    @objc private func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant =  self.maximumContainerHeight
            self.view.layoutIfNeeded()
        }
    }
}

