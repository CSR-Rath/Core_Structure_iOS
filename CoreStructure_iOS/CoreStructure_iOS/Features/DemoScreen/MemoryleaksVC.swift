//
//  MemorleaksVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 22/7/25.
//

import UIKit


//Closure captures self
//Strong delegates
//Timers
//NotificationCenter
//Not removing child VC
//Object never dealloc


class MemoryleaksVC: UIViewController {
    
    lazy var btnDone: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Done", for: .normal)
        btn.backgroundColor = .orange
        
//        btn.actionUIButton = { [weak self] in // privent menory leak use [weak self] in
//
              // deinit is't working
//            let vc = UIViewController()
//            vc.title = "Memory Leak"
//            vc.view.backgroundColor = .white
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
        
        btn.onTouchUpInside = {
            
            // have store reference - deinit isn't wkoring
            
            let vc = UIViewController()
            vc.title = "Memory Leak"
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return btn
    }()
    
  @objc func didTappedDone(){
      let vc = UIViewController()
      vc.title = "Memory Leak"
      vc.view.backgroundColor = .white
      self.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "memory leak"
        view.backgroundColor = .white
        
        view.addSubview(btnDone)
        
        NSLayoutConstraint.activate([
        
            btnDone.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnDone.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnDone.widthAnchor.constraint(equalToConstant: 200),
            btnDone.heightAnchor.constraint(equalToConstant: 50),
        
        ])
        
    }

    deinit {
        print("MyViewController is deinitialized")
    }
}
