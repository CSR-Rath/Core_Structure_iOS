//
//  CrashlyticsViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 25/6/25.
//

import UIKit


class CrashlyticsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let button = UIButton(type: .system)
        button.setTitle("Crash App", for: .normal)
        button.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        button.addTarget(self, action: #selector(crashApp), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func crashApp() {
        let crashlytics = Crashlytics()
        self.pushVC(to: crashlytics)
        
    }
}


class Crashlytics: UIViewController {
    var a: Int! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let button = UIButton(type: .system)
        button.setTitle("Crash App", for: .normal)
        button.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        button.addTarget(self, action: #selector(crashApp), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func crashApp() {
        print("==> a: \(a!)")
        
    }
}
