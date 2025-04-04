//
//  MakeOrderViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/4/25.
//

import UIKit

class ExchangeRate{
    
    
}


class MakeOrderViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    
    private var products: [ProductModel] = []{
        didSet{
            
            var amount = 0.0
            
            if products.count == 0{
                lblTotalAmount.text = "Total amount: \(amount.toCurrencyAsUSD)"
            }else{
                products.forEach({ item in
                    amount += item.amount * Double(item.qty)
                    lblTotalAmount.text = "Total amount: \(amount.toCurrencyAsUSD)"
                })
            }
        }
    }
    
    private let customerTextField = FloatingLabelTextField()
    private let phoneTextField = FloatingLabelTextField()
    private let deliveryTextField = FloatingLabelTextField()
    private let tableView = ContentSizedTableView()
    private let addButton = BaseUIButton()
    private let submitButton = BaseUIButton()
    
    private let lblLocation = SSPaddingLabel()
    private let locationTextView = UITextView()
    private let lblTotalAmount = UILabel()
    private let scrollView = UIScrollView()
    private let viewLine = UIView()
    
    
    private var nsConstrint = NSLayoutConstraint()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        handleAction()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "product_order".localizeString()
        navigationBarAppearance(titleColor: .black, barColor: .white)
        rightBarButtonItem(action: #selector(dismissVC), iconButton: .back)
        //----
        customerTextField.title = "customer_name".localizeString()
        phoneTextField.title = "phone_number".localizeString()
        phoneTextField.keyboardType = .numberPad
        //----
        deliveryTextField.title = "delivery".localizeString()
        deliveryTextField.keyboardType = .decimalPad
        //----
        lblLocation.text = "location".localizeString()
        lblLocation.textColor = .black
        lblLocation.padding = UIEdgeInsets(top: 0, left: 5, bottom: 3, right: 0)
        lblLocation.fontMedium(16)
        
        // Setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cell)
        //----
        lblTotalAmount.textColor = .black
        lblTotalAmount.fontBold(16)
        //----
        addButton.setTitle("product".localizeString(), for: .normal)
        submitButton.setTitle("submit_order".localizeString(), for: .normal)
        
        //Setup UITextView for location with dynamic height
        locationTextView.delegate = self
        locationTextView.layer.borderColor = UIColor.black.cgColor
        locationTextView.layer.borderWidth = 1.5
        locationTextView.layer.cornerRadius = 10
        locationTextView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        
        viewLine.backgroundColor = .black
    
        let stackView = UIStackView(arrangedSubviews: [
            customerTextField,
            phoneTextField,
            deliveryTextField,
            lblLocation,
            locationTextView,
            addButton,
            submitButton,
            lblTotalAmount,
            viewLine,
            tableView,
        ])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(20, after: locationTextView)
        stackView.setCustomSpacing(10, after: addButton)
        stackView.setCustomSpacing(30, after: submitButton)
        stackView.setCustomSpacing(30, after: lblTotalAmount)
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        nsConstrint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        nsConstrint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            locationTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            viewLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
}

// MARK: - Validation button
extension MakeOrderViewController{
    
    @objc private func submitOrder() {
        
        // Retrieve and validate customer name
        guard let customerName = customerTextField.text, !customerName.isEmpty else {
            view.showAlert(title: "missing_info".localizeString(), message: "pleenter_customer_name".localizeString())
            return
        }
        
        // Validate phone number
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
            view.showAlert(title: "missing_info".localizeString(), message: "enter_phone_number".localizeString())
            return
        }
        
        // Validate delivery fee
        guard let deliveryText = deliveryTextField.text, !deliveryText.isEmpty,
              let deliveryFee = Double(deliveryText) else {
            view.showAlert(title: "missing_info".localizeString(), message: "enter_delivery_price".localizeString())
            return
        }
        
        guard let location = locationTextView.text, !location.isEmpty else {
            view.showAlert(title: "missing_info".localizeString(), message: "enter_customer_location".localizeString())
            return
        }
        
        // Create the order model
        let order = MakeOrderModel(
            customerName: customerName,
            phoneNumber: phoneNumber,
            created: Int(Date().timeIntervalSince1970),
            products: products,
            delivery: deliveryFee,
            location: location
        )
        
        print(order) // For testing
    }
}

// MARK: - Action
extension MakeOrderViewController{
    
    func handleAction(){
        
        rightBarButtonItem(action: #selector(dismissKeyboard))
        
        // Handle keyboard appearance/disappearance
        keyboardHandler.onKeyboardWillShow = { height in
            self.nsConstrint.constant = height
            self.view.layoutIfNeeded()
        }
        
        keyboardHandler.onKeyboardWillHide = { _ in
            self.nsConstrint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        
        addButton.actionUIButton = {
            
            let vc = AddProductViewController()
            vc.transitioningDelegate = presentVC
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
            
            vc.didAddProduct = { [self] product in
                self.dismissVC()
                products.append(product)
                tableView.reloadData()
            }
        }
        
        submitButton.actionUIButton = {
            self.submitOrder()
        }
        
    }
}




extension MakeOrderViewController: UITableViewDataSource, UITableViewDelegate  {
    
    
    // UITableView Delegate & DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cell, for: indexPath) as! ProductCell
        cell.selectionStyle = .none
        let product = products[indexPath.row]
        cell.lblName.text = "Product name: \(product.name)"
        cell.lblPrice.text = "Price: \(product.amount)"
        cell.lblQty.text = "Qty: \(product.qty)"
        return cell
    }
    
    // Enable swipe to delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Handle delete product
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // UITextViewDelegate to handle dynamic height adjustment
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = size.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.dismissKeyboard()
    }
    
    
}



extension UIView{
    
    func showAlert(title: String, message: String) {
        guard let window = windowSceneDelegate else{
            print("Present ==> Window is nil")
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localizeString(), style: .default))
        window.rootViewController?.present(alert, animated: true)
    }

}
