//
//  OTPViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 14/9/24.
//

import UIKit

class OTPVC: BaseUIViewConroller {
    var codeTxt: OneTimeCodeTextField!
    
    var btnClear = BaseUIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OTP"
        codeTxt = OneTimeCodeTextField()
       
        
        view.addSubview(codeTxt)
        codeTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            codeTxt.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 0),
            codeTxt.heightAnchor.constraint(equalToConstant: 50),
            codeTxt.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            codeTxt.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            
        ])
        
        // Configure has to be called first
        codeTxt.configure(withSlotCount: 6, andSpacing: 8)  
        codeTxt.keyboardType = .numberPad
        
        view.addSubview(btnClear)
        btnClear.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        btnClear.backgroundColor = .red

        btnClear.setTitle("clear", for: .normal)
        btnClear.addTarget(self, action: #selector(clear), for: .touchUpInside)
 
        
       
        // Get entered Passcode
        codeTxt.didReceiveCode = { [self] code in
            print( "Testing", code)
        
            for index in 0..<code.count{
                codeTxt.digitLabels[index].layer.borderColor = UIColor.green.cgColor
                codeTxt.digitLine[index].backgroundColor = UIColor.green
                
            }
        }
        
        // Clear textfield
        codeTxt.clear()
    }
    
    
   @objc private func clear(){
       codeTxt.clear()
    }
}




