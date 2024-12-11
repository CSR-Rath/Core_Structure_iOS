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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        setupTitleNavigationBar()
        
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitleNavigationBar(font:  UIFont.systemFont(ofSize: 30, weight: .regular),
                                titleColor: .red,
                                backColor: .orange
        )
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hello"
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
      
        rightBarButton()

        //Enable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
  
    }
    
   @objc func buttonTappedAction(){
        print("buttonTappedAction")
        
    }
    
    
}




