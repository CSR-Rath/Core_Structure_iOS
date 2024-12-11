//
//  MakeOrderController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/11/24.
//

import UIKit




class MakeOrderController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    private let tableView = UITableView()
    private let btnViewCart = MainButton()
    private let lblTotal = UILabel()
    
    private var totalAmount : Double =  0{
        didSet{
            lblTotal.text = "Total: " +  totalAmount.twoDigit(sign: "$")
        }
    }
    
    var dataList : [CartItem] = []{
        didSet{
            print("dataList ==> \(dataList)")
            totalAmount = 0
            dataList.forEach({ item in
                totalAmount += (item.product?.price ?? 0) * Double(item.quantity)
            })
            lblTotal.text = "Total: " +  totalAmount.twoDigit(sign: "$")
            tableView.reloadData()
            Loading.shared.hideLoading()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Order Items"
        self.leftBarButton()
        self.view.backgroundColor = .white
        //Enable back swipe gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupUI()
    }
    
    @objc private func pullRefresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [self] in
            tableView.refreshControl?.endRefreshing()
        }
    }
}


extension MakeOrderController{
    
   @objc func didTappedOrder(){
       
      let vc =  PaymentController()
       vc.totalAmount = totalAmount
        vc.cartItems = dataList
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setupUI() {
        
        tableView.addRefreshControl(target: self, action: #selector(pullRefresh))
        btnViewCart.addTargetButton(target: self, action: #selector(didTappedOrder))
        
        view.backgroundColor = .white
        // Set up the table view
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        btnViewCart.setTitle("Make Order", for: .normal)
        btnViewCart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnViewCart)
        
        lblTotal.fontMedium(18)
        lblTotal.textColor = .mainBlueColor
        lblTotal.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(lblTotal)
        view.addSubview(tableView)
        
        // Constraints
        NSLayoutConstraint.activate([

            btnViewCart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnViewCart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            btnViewCart.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            lblTotal.leftAnchor.constraint(equalTo: btnViewCart.leftAnchor),
            lblTotal.bottomAnchor.constraint(equalTo: btnViewCart.topAnchor,constant: -20),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: lblTotal.topAnchor,constant: -15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}


extension MakeOrderController{
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.isFromProductCell = .makeOrder
        cell.selectionStyle = .none
        let product = dataList[indexPath.row].product
        
        cell.imgLogo.image = .image
        cell.lblName.text = "Name: " + (product?.name ?? "")
        cell.lblPrice.text = "Price: " + (product?.price.twoDigit(sign: "$") ?? "")
        cell.lblStock.text = "Stock: " + (product?.stockQuantity.description ?? "")
        cell.imgLogo.image = product?.photo.fromBase64String()
        
        cell.didTappedButton = { [self] in
            
            let pro =  DatabaseManager().getProductById(product?.idHelp ?? "")
            
            if pro?.stockQuantity ?? 0 >= cell.decrementAndIncrement {
                
                dataList[indexPath.row].quantity = cell.decrementAndIncrement
                totalAmount = 0
                dataList.forEach({ item in
                    totalAmount += (item.product?.price ?? 0) * Double(item.quantity)
                })
                
            }else{
                AlertMessage.shared.alertError(title: "Message", message: "Product Quantity is Over.")
                cell.decrementAndIncrement -= 1
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

