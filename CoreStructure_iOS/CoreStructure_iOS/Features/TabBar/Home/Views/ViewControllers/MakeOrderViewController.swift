////
////  MakeOrderViewController.swift
////  CoreStructure_iOS
////
////  Created by Rath! on 4/4/25.
////
//
//import UIKit
//import FirebaseFirestore
//
//class ExchangeRate{
//    
//    
//}
//
//
//class MakeOrderViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
//    
//    private var totalAmount = 0.0
//    
//    private var deliveryAmount: Double = 0{
//        didSet{
//            
//        }
//    }
//    
//    private var products: [ProductModel] = []{
//        didSet{
//            
//            calculatorTotalAmount()
//        }
//    }
//    
//    private var makeOrder : MakeOrderModel?
//    
//    func calculatorTotalAmount(){
//        var amount = 0.0
//        
//        deliveryAmount = Double(deliveryTextField.text ?? "") ?? 0
//        
//        if products.count == 0{
//            
//            lblTotalAmount.text = "Delivery: \(deliveryAmount)\nSub Total: UDS 0.00\nTotal amount: \(deliveryAmount.toCurrencyAsUSD)"
//        }else{
//            
//            products.forEach({ item in
//                amount += (item.amount! * Double(item.qty!))
//                
//                let total:Double = amount + deliveryAmount
//                
//                lblTotalAmount.text = "Delivery: \(deliveryAmount.toCurrencyAsUSD)\nSub Total: \(amount.toCurrencyAsUSD)\nTotal amount: \(total.toCurrencyAsUSD)"
//            })
//        }
//    }
//    
//    private let customerTextField = FloatingLabelTextField()
//    private let phoneTextField = FloatingLabelTextField()
//    private let deliveryTextField = FloatingLabelTextField()
//    private let tableView = ContentSizedTableView()
//    private let addButton = BaseUIButton()
//    private let submitButton = BaseUIButton()
//    private let submitButton2 = BaseUIButton()
//    private let submitButton3 = BaseUIButton()
//    
//    private let submitButton4 = BaseUIButton()
//    
//    private let lblLocation = SSPaddingLabel()
//    private let locationTextView = FloatingLabelTextField()
//    private let lblTotalAmount = UILabel()
//    private let scrollView = UIScrollView()
//    private let viewLine = UIView()
//    
//    private var nsConstrint = NSLayoutConstraint()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        handleAction()
//    }
//    
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        navigationItem.title = "product_order".localizeString()
////        navigationBarAppearance(titleColor: .black, barColor: .white)
//        rightBarButtonItem(action: #selector(dismissVC), iconButton: .back)
//        //----
//        customerTextField.title = "customer_name".localizeString()
//        phoneTextField.title = "phone_number".localizeString()
//        phoneTextField.keyboardType = .numberPad
//        //----
//        deliveryTextField.title = "delivery".localizeString()
//        deliveryTextField.keyboardType = .decimalPad
//        //----
//        lblLocation.text = "location".localizeString()
//        lblLocation.textColor = .black
//        lblLocation.padding = UIEdgeInsets(top: 0, left: 5, bottom: 3, right: 0)
//        lblLocation.fontMedium(16)
//        
//        // Setup TableView
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cell)
//        //----
//        lblTotalAmount.numberOfLines = 0
//        lblTotalAmount.textColor = .black
//        lblTotalAmount.fontMedium(16)
//        //----
//        addButton.setTitle("product".localizeString(), for: .normal)
//        submitButton.setTitle("submit_order".localizeString(), for: .normal)
//        
//        locationTextView.title = "location".localizeString()
//        viewLine.backgroundColor = .black
//        
//        let stackView = UIStackView(arrangedSubviews: [
////            customerTextField,
////            phoneTextField,
////            deliveryTextField,
////            locationTextView,
//            addButton,
//            submitButton,
//            submitButton2,
//            submitButton3,
//            submitButton4
////            lblTotalAmount,
////            viewLine,
////            tableView,
//        ])
//        stackView.axis = .vertical
//        stackView.spacing = 0
//        stackView.alignment = .fill
//        stackView.distribution = .fill
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.setCustomSpacing(20, after: locationTextView)
//        stackView.setCustomSpacing(10, after: addButton)
//        stackView.setCustomSpacing(30, after: submitButton)
//        stackView.setCustomSpacing(30, after: lblTotalAmount)
//        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//        stackView.isLayoutMarginsRelativeArrangement = true
//        
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//        scrollView.addSubview(stackView)
//        
//        nsConstrint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//        nsConstrint.isActive = true
//        
//        NSLayoutConstraint.activate([
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
//            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
//            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            locationTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
//            viewLine.heightAnchor.constraint(equalToConstant: 1),
//        ])
//        
////        submitButton.isActionButton = false
//        
//        customerTextField.didEditingChanged = {
//            self.validaionButton()
//        }
//        
//        phoneTextField.didEditingChanged = {
//            self.validaionButton()
//        }
//        
//        deliveryTextField.didEditingChanged = {
//            self.validaionButton()
//            self.calculatorTotalAmount()
//        }
//        
//        locationTextView.didEditingChanged = {
//            self.validaionButton()
//        }
//        
//        addButton.setTitle("Save", for: .normal)
//        addButton.actionUIButton = {
//            let model = MakeOrderModel(
//                id: 1,
//                customerName: "Sophearath",
//                phoneNumber: "012345678",
//                created: Int(Date().timeIntervalSince1970),
//                products: [ProductModel(name: "iPhone", amount: 1200.0, qty: 1)],
//                delivery: 5.0,
//                location: "Phnom Penh"
//            )
//
//            FirebaseManager.shared.saveDataFirebase(dbName: .orders, modelCodable: model) { success in
//                print("Save result: \(success)")
//            }
//        }
//        
//        submitButton2.setTitle("get all", for: .normal)
//        submitButton2.actionUIButton = {
//            FirebaseManager.shared.getAllData(dbName: .orders, modelType: MakeOrderModel.self) { models in
//                print("Orders:", models ?? [])
//            }
//        }
//        
//        submitButton3.setTitle("Fetched id", for: .normal)
//        submitButton3.actionUIButton = {
//            
//            FirebaseManager.shared.getDataById(dbName: .orders, documentID: "1", modelType: MakeOrderModel.self) { model in
//                print("Fetched:", model!)
//            }
//        }
//        
//        
//        submitButton.setTitle("Up id", for: .normal)
//        submitButton.actionUIButton =  {
//            let updated = MakeOrderModel(
//                id: 1,
//                customerName: "Rath Updated",
//                phoneNumber: "099999999",
//                created: Int(Date().timeIntervalSince1970),
//                products: [ProductModel(name: "MacBook", amount: 2000.0, qty: 1)],
//                delivery: 10.0,
//                location: "Siem Reap"
//            )
//
//            FirebaseManager.shared.updateDataById(dbName: .orders, documentID: "1", updatedModel: updated) { success in
//                print("Update:", success)
//            }
//
//            
//        }
//        
//        submitButton4.actionUIButton = {
//            FirebaseManager.shared.deleteById(dbName: .orders, modelID: 1) { s in
//                
//            }
//        }
//    }
//    
//}
//
//// MARK: - Validation button
//extension MakeOrderViewController{
//    
//    func validaionButton(){
//        
////        submitButton.isActionButton = false
//        // Retrieve and validate customer name
//        guard let customerName = customerTextField.text, !customerName.isEmpty else {
//            return
//        }
//        
//        // Validate phone number
//        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
//            return
//        }
//        
//        // Validate delivery fee
//        guard let deliveryText = deliveryTextField.text, !deliveryText.isEmpty,
//              let deliveryFee = Double(deliveryText) else {
//            return
//        }
//        
//        guard let location = locationTextView.text, !location.isEmpty else {
//            return
//        }
//        
//        if products.count > 0{
//            submitButton.isActionButton = true
//            
//            makeOrder = MakeOrderModel(
//                id: 2,
//                customerName: customerName,
//                phoneNumber: phoneNumber,
//                created: Int(Date().timeIntervalSince1970),
//                products: products,
//                delivery: deliveryFee,
//                location: location
//            )
//        }
//        
//    }
//    
//    func submitOrder() {
//        
//        FirebaseManager.shared.saveDataFirebase(dbName: .orders, modelCodable: makeOrder) { status in
//            
//        }
//        
//    }
//    
//    func testFirestoreWrite() {
//        
////        FirebaseManager.shared.getDataFromFirebase(dbName: .orders, modelType: MakeOrderModel.self) { makeOrder, status in
////            print("makeOrder ==>\(makeOrder)")
////        }
//    }
//    
//}
//
//// MARK: - Action
//extension MakeOrderViewController{
//    
//    func handleAction(){
//        
//        rightBarButtonItem(action: #selector(dismissKeyboard))
//        
//        // Handle keyboard appearance/disappearance
//        keyboardHandler.onKeyboardWillShow = { height in
//            self.nsConstrint.constant = height
//            self.view.layoutIfNeeded()
//        }
//        
//        keyboardHandler.onKeyboardWillHide = { _ in
//            self.nsConstrint.constant = 0
//            self.view.layoutIfNeeded()
//        }
//        
////        addButton.actionUIButton = {
////            
////            let vc = AddProductViewController()
////            vc.transitioningDelegate = presentVC
////            vc.modalPresentationStyle = .custom
////            self.present(vc, animated: true)
////            
////            vc.didAddProduct = { [self] product in
////                self.dismissVC()
////                products.append(product)
////                tableView.reloadData()
////                validaionButton()
////            }
////        }
//        
////        submitButton.actionUIButton = {
//////            self.submitOrder()
////        }
//        
//    }
//    
//}
//
//
//
//
//extension MakeOrderViewController: UITableViewDataSource, UITableViewDelegate  {
//    
//    // UITableView Delegate & DataSource Methods
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return products.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cell, for: indexPath) as! ProductCell
//        cell.selectionStyle = .none
//        let product = products[indexPath.row]
//        cell.lblName.text = "Product name: \(product.name)"
//        cell.lblPrice.text = "Price: \(product.amount)"
//        cell.lblQty.text = "Qty: \(product.qty)"
//        return cell
//    }
//    
//    // Enable swipe to delete
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    // Handle delete product
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            products.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
//    
//    // UITextViewDelegate to handle dynamic height adjustment
//    func textViewDidChange(_ textView: UITextView) {
//        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
//        textView.constraints.forEach { constraint in
//            if constraint.firstAttribute == .height {
//                constraint.constant = size.height
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        view.dismissKeyboard()
//    }
//    
//}
//
//
//
//extension UIView{
//    
//    func showAlert(title: String, message: String) {
//        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootPresent = windowScene.windows.first?.rootViewController,
//              let rootPush = windowScene.windows.first?.rootViewController as? UINavigationController
//        else { return }
//        
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "ok".localizeString(), style: .default))
//        rootPresent.present(alert, animated: true)
//    }
//    
//}
