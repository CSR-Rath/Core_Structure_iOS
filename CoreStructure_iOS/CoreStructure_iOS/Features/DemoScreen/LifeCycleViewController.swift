//
//  LifeCycaleViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/7/25.
//

import UIKit

class LifeCycleViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        print("\n\n\nloadView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LifeCycleViewController"
        print("viewDidLoad")
        view.backgroundColor = .white
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    }
    
    deinit{
        print("deinit")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = APITheSameTimeVC()
        vc.title = "Testing LoadView"
        vc.view.backgroundColor = .white
        
        self.pushVC(to: vc)
    }
    

}

//import UIKit

//class MyCustomViewController: UIViewController {
//    
//    override func loadView() {
//        // 1. Create the main view
//        let view = UIView()
//        view.backgroundColor = .white
//
//        // 2. Create a label
//        let label = UILabel()
//        label.text = "Hello, loadView!"
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 24)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        // 3. Create a button
//        let button = UIButton(type: .system)
//        button.setTitle("Tap Me", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//
//        // 4. Add subviews
//        view.addSubview(label)
//        view.addSubview(button)
//
//        // 5. Add constraints
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
//
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
//        ])
//
//        // 6. Assign the view to self.view
//        self.view = view
//    }
//
//    @objc func buttonTapped() {
//        print("Button was tapped!")
//    }
//}



