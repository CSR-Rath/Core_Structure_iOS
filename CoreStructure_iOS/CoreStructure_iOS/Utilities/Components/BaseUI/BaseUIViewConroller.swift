//
//  BaseUIViewConroller.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/6/25.
//

import UIKit

class BaseUIViewConroller: UIViewController, UIGestureRecognizerDelegate {
    
    var isLeftBarButtonItem = true{
        didSet{
            setupLeftBarButtonItem()
        }
    }
    
    var isInteractivePopGestureRecognizer = true{
        didSet{
            setupInteractivePopGestureRecognizer()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftBarButtonItem()
        setupInteractivePopGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupInteractivePopGestureRecognizer(){
        
        if isInteractivePopGestureRecognizer{
            
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }else{
            
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        
    }
    
    
   private func setupLeftBarButtonItem(){
        
        if isLeftBarButtonItem {
            
//            leftBarButtonItem()
        }else{
            
            self.navigationItem.leftBarButtonItem = nil
        }
    }
}
