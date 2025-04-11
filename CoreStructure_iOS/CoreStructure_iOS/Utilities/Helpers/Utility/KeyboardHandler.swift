//
//  KeyboardHandler.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import UIKit

let keyboardHandler = KeyboardHandler()

class KeyboardHandler {
    
    var onKeyboardWillShow: ((_ keyboardHeight: CGFloat) -> Void)?
    var onKeyboardWillHide: ((_ bottomSafeAreaInsetsHeight: CGFloat) -> Void)?
    
    init() {
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height //+ 10  // Adding extra padding
            self.onKeyboardWillShow?(-keyboardHeight);  print("Keyboard height: \(keyboardHeight)")
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        onKeyboardWillHide?(bottomSafeAreaInsetsHeight); print("Keyboard will hide")
    }
}




//class ScrollViewRefreshManager {
//    
//    private weak var scrollView: UIScrollView?
//    private var refreshControl: UIRefreshControl?
//    
//    init(scrollView: UIScrollView, target: Any, action: Selector) {
//        self.scrollView = scrollView
//        setupRefreshControl(target: target, action: action)
//    }
//    
//    private func setupRefreshControl(target: Any, action: Selector) {
//        let refreshControl = UIRefreshControl()
//        refreshControl.tintColor = .systemBlue // Customize the color
//        refreshControl.addTarget(target, action: action, for: .valueChanged)
//        
//        if let tableView = scrollView as? UITableView {
//            tableView.refreshControl = refreshControl
//        } else if let collectionView = scrollView as? UICollectionView {
//            collectionView.refreshControl = refreshControl
//        } else {
//            scrollView?.insertSubview(refreshControl, at: 0)
//        }
//        
//        self.refreshControl = refreshControl
//    }
//    
//    func endRefreshing() {
//        refreshControl?.endRefreshing()
//    }
//}

//class ViewControllerdsf: UIViewController {
//    
//    private var refreshManager: ScrollViewRefreshManager?
//    private let tableView = UITableView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Setup tableView (or collectionView, scrollView)
//        tableView.frame = view.bounds
//        view.addSubview(tableView)
//        
//        // Initialize the refresh manager
//        refreshManager = ScrollViewRefreshManager(scrollView: tableView,
//                                                  target: self,
//                                                  action: #selector(refreshData))
//    }
//    
//    @objc private func refreshData() {
//        // Simulate data refresh
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.refreshManager?.endRefreshing()
//        }
//    }
//}



