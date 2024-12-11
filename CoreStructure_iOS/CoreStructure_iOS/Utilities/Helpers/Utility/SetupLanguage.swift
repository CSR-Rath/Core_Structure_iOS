//
//  SetupLanguage.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 7/11/24.
//

import Foundation

func setLanguage(langCode: String) {
    UserDefaults.standard.setValue(langCode, forKey: KeyUser.language)
}

extension String {
    func localizeString() -> String {
        let lang = UserDefaults.standard.string(forKey: KeyUser.language)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}


import UIKit

//class MainViewController: UIViewController {
//    
//    var sideMenuViewController: SideMenuViewController!
//    var isMenuOpen = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .cyan
//        
//        // Setup side menu
//        sideMenuViewController = SideMenuViewController()
//        view.addSubview(sideMenuViewController.view)
//        addChild(sideMenuViewController)
//        sideMenuViewController.didMove(toParent: self)
////        sideMenuViewController.view.backgroundColor = .orange
//        
//        // Position the side menu off-screen
//        sideMenuViewController.view.frame = CGRect(x: -view.frame.width,
//                                                   y: 0,
//                                                   width: view.frame.width*0.8,
//                                                   height: view.frame.height)
//        
//        // Add a button to open the menu
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(toggleMenu))
//        
//        // Add swipe gesture
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        view.addGestureRecognizer(panGesture)
//    }
//    
//    @objc func toggleMenu() {
//        isMenuOpen.toggle()
//        let menuPosition = isMenuOpen ? 0 : -view.frame.width
//        UIView.animate(withDuration: 0.3) {
//            self.sideMenuViewController.view.frame.origin.x = menuPosition
//        }
//    }
//    
//    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: view).x
//        if gesture.state == .changed {
//            if translation > 0 { // Swiping right
//                sideMenuViewController.view.frame.origin.x = max(-view.frame.width + translation, 0)
//            }
//        } else if gesture.state == .ended {
//            let shouldOpen = translation > view.frame.width / 2
//            isMenuOpen = shouldOpen
//            toggleMenu()
//        }
//    }
//}

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .orange
        
        // Setup table view
        tableView.backgroundColor = .orange
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "Menu Item \(indexPath.row + 1)"
        return cell
    }
}
