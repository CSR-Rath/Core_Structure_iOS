//
//  HtmlVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 7/11/24.
//

import Foundation
import UIKit

class HtmlVC: UIViewController, UIGestureRecognizerDelegate{
    
    //MARK: - how to use it
    lazy var descriptionLbl: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.backgroundColor = .clear//.mainColor
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = true // isSroll true
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
}


let htmlString: String = ""
