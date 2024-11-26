//
//  BVM_VIP_VC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/11/24.
//

import UIKit

class BVM_VIP_VC: UIViewController {
    
    let bvm_VIP_View = BVM_VIP_View()
    
    override func loadView() {
        super.loadView()
        view = bvm_VIP_View
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
    }
    
}
