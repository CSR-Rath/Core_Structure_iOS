//
//  PaymentController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 29/11/24.
//

import UIKit

class PaymentController: UIViewController {
    
    var isPaymentCash: Bool = false
    
    let tableView = UITableView()
    let btnPayment = MainButton()
    var cartItems : [CartItem] = []
    var totalAmount: Double = 0
    
    let dataList : [TitleValueModel] = [
        TitleValueModel(title: "Cash", value: "imgCash"),
        TitleValueModel(title: "KHQR", value: "ImgKHQR")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftBarButton()
        view.backgroundColor = .white
        
        // Set up the table view
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isMultipleTouchEnabled = true
        tableView.register(PaymentCell.self, forCellReuseIdentifier: "PaymentCell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    private func setupUI(){
        
        btnPayment.isActionButton = false
        btnPayment.setTitle("Payment", for: .normal)
        btnPayment.translatesAutoresizingMaskIntoConstraints = false
        btnPayment.addTargetButton(target: self, action: #selector(didTappedPayment))
        view.addSubview(btnPayment)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
        
            btnPayment.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            btnPayment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            btnPayment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: btnPayment.topAnchor, constant: -10),

        ])

    }
    
   @objc func didTappedPayment(){
       Loading.shared.showLoading()
       DatabaseManager().processPayment(for: cartItems, paymentType: isPaymentCash ? "Cash" : "KHQR")
       
       // Cut Stock quantity product by table isn't reletionship
       cartItems.forEach({ item in
           DatabaseManager().updateStockQuantity(productId: item.product?.idHelp ?? "", newQuantity: item.quantity)
       })
       
       if isPaymentCash {
           let targetViewController = TransationDeatilController()
           isFromNotification = true
           targetViewController.dataList =  DatabaseManager().getLastTransactionByIndex() ?? Transaction()
           self.navigationController?.pushViewController(targetViewController, animated: true)
           
       }else{
           Loading.shared.hideLoading()
           let vc = QRCodeController()
           vc.lblAmount.text = totalAmount.twoDigit(sign: "$")
           self.navigationController?.pushViewController(vc, animated: true)
       }
        
    }
    
}

extension PaymentController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
        let data = dataList[indexPath.row]
        
        cell.imageLogo.image = UIImage(named: data.value)
        cell.lblName.text = data.title + "\t" + totalAmount.twoDigit(sign: "USD")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnPayment.isActionButton = true
        
        if  indexPath.row == 0{
            isPaymentCash = true
        }else{
            isPaymentCash = false
        }

    }
}

class PaymentCell : UITableViewCell{
    
    let bgView = UIView()
    let imageLogo = UIImageView()
    let lblName = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        bgView.layer.borderColor = selected ?  UIColor.mainBlueColor.cgColor :  UIColor.clear.cgColor
    }
    
    private func setupUI(){
        bgView.layer.cornerRadius = 10
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = UIColor.clear.cgColor
        bgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bgView)
        
        imageLogo.contentMode = .scaleAspectFit
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageLogo)
       
        lblName.text = "_"
        addSubview(lblName)
        lblName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bgView.leftAnchor.constraint(equalTo: leftAnchor,constant: 15),
            bgView.rightAnchor.constraint(equalTo: rightAnchor,constant: -15),
            
            imageLogo.heightAnchor.constraint(equalToConstant: 50),
            imageLogo.widthAnchor.constraint(equalToConstant: 80),
            imageLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageLogo.leftAnchor.constraint(equalTo: bgView.leftAnchor,constant: 15),
            
            lblName.leftAnchor.constraint(equalTo: imageLogo.rightAnchor,constant: 10),
            lblName.centerYAnchor.constraint(equalTo: centerYAnchor),
    
        ])
    }
}
