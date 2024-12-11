//
//  TransationDeatilController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 1/12/24.
//

import UIKit

var isFromNotification: Bool = false

class TransationDeatilController: UIViewController {

    var dataList : Transaction = Transaction()  {
        didSet{
            print("dataList \(dataList)")
            tableView.reloadData()
            Loading.shared.hideLoading()
        }
    }
    
    
    
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromNotification {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            isFromNotification = false
            leftBarButton(action: #selector(didTabppedLeft),
                          iconButton: .icCloseMain)
        }else{
            leftBarButton()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.frame = view.bounds
        tableView.register(TransationDeatilCell.self, forCellReuseIdentifier: "TransationDeatilCell")
        view.addSubview(tableView)
    }
    
    @objc func didTabppedLeft(){
        pushNoback(newVC: HomeController())
    }

}


extension TransationDeatilController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.cartItems.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransationDeatilCell", for: indexPath) as! TransationDeatilCell
        cell.selectionStyle = .none
        
        let lastRow = tableView.numberOfRows(inSection: 0)-1
        
        if indexPath.row == 0{
            cell.lblName.fontBold(16)
            cell.lblName.text = "Order Items"
            cell.lblValue.text = ""
        }else if indexPath.row == lastRow{
            cell.lblName.text = "Total Amount"
            cell.lblValue.text = dataList.totalAmount.twoDigit(sign: "$")
            cell.lblName.fontBold(16)
            cell.lblValue.fontBold(16)
        }else{
            let data = dataList.cartItems[indexPath.row-1]
            
            let price: Double = Double(data.quantity) * (data.product?.price ?? 0)
            
            cell.lblName.text = data.product?.name ?? "_"
            cell.lblValue.text = "\(data.quantity) * \(data.product?.price ?? 0) = " + price.twoDigit(sign: "$")
            cell.lblName.fontRegular(16)
            cell.lblValue.fontRegular(16)
        }

        return cell
        
    }
    
}


class TransationDeatilCell: UITableViewCell{
    
    
    let lblName = UILabel()
    let lblValue = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        let stack = UIStackView(arrangedSubviews: [lblName,lblValue])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            stack.leftAnchor.constraint(equalTo: leftAnchor,constant: 20),
            stack.rightAnchor.constraint(equalTo: rightAnchor,constant: -20),
        
        ])
        
    }
}
