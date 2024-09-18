//
//  OTPViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 14/9/24.
//

import UIKit



//class ViewController: UIViewController {
//    var optTextField =  UITextField()
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        optTextField.resignFirstResponder()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        optTextField.translatesAutoresizingMaskIntoConstraints = false
//        optTextField.textContentType = .oneTimeCode
//        optTextField.keyboardType = .numberPad
//        optTextField.backgroundColor = .orange
//
//        view.addSubview(optTextField)
//
//        NSLayoutConstraint.activate([
//
//            optTextField.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
//            optTextField.heightAnchor.constraint(equalToConstant: 50),
//            optTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
//            optTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
//
//        ])
//    }
//}

//class OTPView: UIView{
//
//    lazy var label: UILabel = {
//        let lbl = UILabel()
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.numberOfLines = 1
//        lbl.textAlignment = .center
//        return lbl
//    }()
//
//    lazy var lineView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .orange
//        return view
//    }()
//
//    lazy var stackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [label,lineView])
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.spacing = 10
//        stack.distribution = .fill
//        stack.alignment = .fill
//        return stack
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    private func setupConstraint(){
//
//        NSLayoutConstraint.activate([
//
//            stackView.topAnchor.constraint(equalTo: topAnchor),
//            stackView.leftAnchor.constraint(equalTo: leftAnchor),
//            stackView.rightAnchor.constraint(equalTo: rightAnchor),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            lineView.heightAnchor.constraint(equalToConstant: 1)
//
//        ])
//    }
//}

class ViewController: UIViewController {
    var codeTxt: OneTimeCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        codeTxt = OneTimeCodeTextField()
        
        view.addSubview(codeTxt)
        codeTxt.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            codeTxt.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            codeTxt.heightAnchor.constraint(equalToConstant: 50),
            codeTxt.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            codeTxt.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            
        ])
        
        // Configure has to be called first
        codeTxt.configure(withSlotCount: 6, andSpacing: 8)              // Default: 6 slots, 8 spacing
        codeTxt.keyboardType = .numberPad
        
        // Customisation(Optional)
        codeTxt.codeBackgroundColor = .secondarySystemBackground        // Default: .secondarySystemBackground
        codeTxt.codeTextColor = .label                                  // Default: .label
        codeTxt.codeFont = .systemFont(ofSize: 30, weight: .black)      // Default: .system(ofSize: 24)
        codeTxt.codeMinimumScaleFactor = 0.2                            // Default: 0.8
        
        codeTxt.codeCornerRadius = 12                                   // Default: 8
        codeTxt.codeCornerCurve = .continuous                           // Default: .continuous
        
        codeTxt.codeBorderWidth = 1                                     // Default: 0
        codeTxt.codeBorderColor = .label                                // Default: .none
        
        // Allow none-numeric code
        codeTxt.oneTimeCodeDelegate.allowedCharacters = .alphanumerics  // Default: .decimalDigits
        
        //You should also specify which corresponding keyboard should be shown
//        codeTxt.keyboardType = .asciiCapable                            // Default: .numberPad
        
        // Get entered Passcode
        codeTxt.didReceiveCode = { code in
            print( "Testing", code)
        }
        
        // Clear textfield
        codeTxt.clear()
    }
}
