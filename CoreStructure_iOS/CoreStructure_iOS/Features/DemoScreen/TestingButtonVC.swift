//
//  TestingButtonVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/3/25.
//

import Foundation
import UIKit

class TestingButtonVC: BaseUIViewConroller{
    var  btn =  BaseUIButton()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Testing Button"
        view.backgroundColor = .white
        
        let button = CustomUIButton()
        button.setTitle("Tap Me", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTargetButton(target: self, action: #selector(didTapped))
        button.frame = CGRect(x: 100, y: 400, width: 200, height: 50)
        view.addSubview(button)
       
        btn = BaseUIButton(frame: CGRect(x: 100, y: 500, width: 200, height: 50))
        btn.setTitle("Tap Me", for: .normal)
        btn.onTouchUpInside = {
            self.btn.startLoading()
        }
        view.addSubview(btn)
    }
    
    
   @objc func didTapped(){
       btn.stopLoading()
        print("didTapped")
       
       let vc = UIViewController()
       vc.view.backgroundColor = .blue
       pushVC(to: vc)
        print("didTapped")
    }
}

class CustomUIButton: UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundImage(pixel(ofColor: .orange), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1, height: 1)

      UIGraphicsBeginImageContext(pixel.size)
      defer { UIGraphicsEndImageContext() }

      guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

      context.setFillColor(color.cgColor)
      context.fill(pixel)

      return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
}
