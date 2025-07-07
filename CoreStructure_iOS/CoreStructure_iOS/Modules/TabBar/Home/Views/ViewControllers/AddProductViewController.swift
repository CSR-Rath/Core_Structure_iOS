//
//  AddProductViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/4/25.
//

import UIKit

//class AddProductViewController: UIViewController {
//    
//    var product = ProductModel(name: "", amount: 0, qty: 0)
//    
//    var didAddProduct: ((_ product: ProductModel)->())?
//    
//    private let txtName = FloatingLabelTextField()
//    private let txtPrice = FloatingLabelTextField()
//    private let txtQty = FloatingLabelTextField()
//    private let btnAdd = BaseUIButton()
//    
//    lazy var selectView: SingleSelectView = {
//        let view = SingleSelectView()
//        view.itemsList = ["USD"] //["USD", "KHR"]
//        view.defaultSelect = 0
//        view.didSelectCell = { [self] index in
//            txtPrice.resignFirstResponder()
//            if index == 0 {
//                txtPrice.keyboardType = .decimalPad
//            }else{
//                txtPrice.keyboardType = .numberPad
//            }
//            txtPrice.becomeFirstResponder()
//        }
//        return view
//    }()
//    
//    lazy var stackPrice: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [
//            txtPrice,
//            selectView,
//        ])
//        stack.axis = .horizontal
//        stack.distribution = .fill
//        stack.spacing = 10
//        return stack
//    }()
//    
//    lazy var stackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [
//            txtName,
//            stackPrice,
//            txtQty,
//            btnAdd,
//        ])
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 35, right: 20)
//        stack.isLayoutMarginsRelativeArrangement = true
//        stack.axis = .vertical
//        stack.spacing = 10
//        stack.backgroundColor = .white
//        stack.layer.cornerRadius = 10
//        return stack
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .clear
//        let viewDismiss = UIView(frame: view.bounds)
//        viewDismiss.addGestureView(target: self, action: #selector(dismissVC))
//        view.addSubview(viewDismiss)
//        setupUI()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        txtName.becomeFirstResponder()
//    }
//    
//    private func setupUI(){
//        btnAdd.isActionButton = false
//        txtName.title = "product_name".localizeString()
//        txtPrice.title = "price".localizeString()
//        txtQty.title = "qty".localizeString()
//        txtQty.text = "1"
//        
//        txtPrice.keyboardType = .decimalPad
//        txtQty.keyboardType = .numberPad
//        
//        btnAdd.setTitle("add_product".localizeString(), for: .normal)
//  
//        view.addSubview(stackView)
//        NSLayoutConstraint.activate([
//
//            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
//            
//            selectView.widthAnchor.constraint(equalTo: stackPrice.widthAnchor, multiplier: 0.25),
//        ])
//        
//        btnAdd.actionUIButton = {
//            self.addProduct()
//        }
//        
//        txtName.didEditingChanged = {
//            self.validationTextField()
//        }
//        
//        txtPrice.didEditingChanged = {
//            
//            self.validationTextField()
//            
//        }
//        
//        txtQty.didEditingChanged = {
//            self.validationTextField()
//        }
//     
//    }
//    
//    private func validationTextField(){
//        btnAdd.isActionButton = false
//        
//        guard let name = txtName.text, !name.isEmpty else {
//            return
//        }
//        
//        guard let priceText = txtPrice.text, !priceText.isEmpty,
//              let price = Double(priceText) else {
//            return
//        }
//        
//        guard let qtyText = txtQty.text, !qtyText.isEmpty,
//              let qty = Int(qtyText), qty > 0 else {
//            return
//        }
//        
//        btnAdd.isActionButton = true
//    }
//    
//    
//    func addProduct(){
//        
//        guard let name = txtName.text, !name.isEmpty else {
//               return
//           }
//           
//           guard let priceText = txtPrice.text, !priceText.isEmpty,
//                 let price = Double(priceText) else {
//               return
//           }
//           
//           guard let qtyText = txtQty.text, !qtyText.isEmpty,
//                 let qty = Int(qtyText), qty > 0 else {
//               return
//           }
//        
//        
//        product = ProductModel(name: name, amount: price, qty: qty)
//        didAddProduct?(product)
//        
//    }
//    
//}


