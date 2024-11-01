//
//  FullVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 31/10/24.
//

import UIKit

class HandleNavigationBarVC: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var tableView: UITableView = {
        let table  = UITableView()
        table.backgroundColor = .white
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        title = "Hello"
        
    
        //MARK: Setup Button left and right
        leftBarButton()
        rightBarButton()
        

        //MARK: Setup navigationBar
        // setup title font color
        let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold),
                              NSAttributedString.Key.foregroundColor: UIColor.white
        ]
       
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        appearance.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        //Enable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
  
    }
    
   @objc func buttonTappedAction(){
        print("buttonTappedAction")
        
    }
    
    
}
