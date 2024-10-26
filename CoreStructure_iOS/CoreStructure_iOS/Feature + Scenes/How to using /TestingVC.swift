//
//  TestingVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 25/10/24.
//

import UIKit

class TestingVC: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        AlertMessage.shared.alertError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
    



}
