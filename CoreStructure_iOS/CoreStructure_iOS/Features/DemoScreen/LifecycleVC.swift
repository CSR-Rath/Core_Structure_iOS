//
//  LifecycleVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 9/7/25.
//

import UIKit

class LifecycleVC: BaseUIViewConroller {

    override func loadView() {
        super.loadView()
        print("loadView called")
        // If creating views programmatically without storyboard, create and assign view here
        // self.view = UIView()
        // self.view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lifecycle ViewController"
        print("viewDidLoad called")
        // Setup initial UI and data
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        // Prepare UI each time before view appears
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear called")
        // Start animations, analytics, or tasks that require view to be visible
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear called")
        // Pause tasks, save state
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear called")
        // Stop animations, release resources if needed
    }
    
    deinit {
        print("MyViewController deinit called")
    }
}
