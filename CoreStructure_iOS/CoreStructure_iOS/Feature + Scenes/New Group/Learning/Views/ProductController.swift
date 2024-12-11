//
//  ProductController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/11/24.
//



import UIKit

struct ID_Value_Model{
    var id : String
    var value : Bool = false
}

class ProductController: UIViewController, UIGestureRecognizerDelegate {
    
    private let tableView = UITableView()
    private let lblTotal = UILabel()
    private let btnViewCart = MainButton()
    
    private var products: [Product] = []{
        didSet{
            repeatingArray.removeAll()
            products.forEach({ item in
                repeatingArray.append(ID_Value_Model(id: item.id, value: false))
            })
        }
    }
    
    private var repeatingArray: [ID_Value_Model] = []{
        didSet{
            
            var isNoSelected: Bool = false
            var  count = 0
            
            repeatingArray.forEach({ item in
                if item.value{
                    isNoSelected = true
                    count += 1
                    
                }
            })
            
            lblTotal.text = "Count: \(count)"
            btnViewCart.isActionButton = isNoSelected
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
            Loading.shared.hideLoading(0.1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTitleNavigationBar(titleColor: .white, backColor: .mainBlueColor)
        
        if  UserDefaults.standard.string(forKey: KeyUser.userType) == UserTypeEnum.store.rawValue{
            self.title = "Select Items"
            lblTotal.isHidden = false
            btnViewCart.isHidden = false
        }else{
            self.title = "Products"
            lblTotal.isHidden = true
            btnViewCart.isHidden = true
            self.rightBarButton(action: #selector(addProductTapped), iconButton: .icAdd)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = DatabaseManager().fetchProducts()
        self.leftBarButton()
       
        self.view.backgroundColor = .white
        //Enable back swipe gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupUI()
        tableView.addRefreshControl(target: self, action: #selector(pullRefresh))
        
    }
    
    @objc private func pullRefresh(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [self] in
            products = DatabaseManager().fetchProducts()
        }
    }
    
    
}

extension ProductController{
    
    @objc private func tappedViewCart() {
        Loading.shared.showLoading()
        
        let makeOrderVC = MakeOrderController()
        var cartIems : [CartItem] = []
        
        for (index, items) in repeatingArray.enumerated(){
            if items.value{
                
                let cartIem = CartItem()
                let productCart = ProductCart()
                productCart.idHelp = products[index].id
                productCart.name = products[index].name
                productCart.price = products[index].price
                productCart.photo = products[index].photo
                productCart.stockQuantity = products[index].stockQuantity
                cartIem.product = productCart

                cartIems.append(cartIem)
            }
            
        }
        makeOrderVC.dataList = cartIems
        navigationController?.pushViewController(makeOrderVC, animated: true)
    }
    
    @objc private func addProductTapped() {
        let addProductVC = CreateAndUpdateProductController()
        addProductVC.isEnumCreateOrUpdate = .create
        navigationController?.pushViewController(addProductVC, animated: true)
    }
    
    private func setupUI() {
        
        // Set up the table view
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isMultipleTouchEnabled = true
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        btnViewCart.isActionButton = false
        btnViewCart.setTitle("View Your Cart", for: .normal)
        btnViewCart.addTargetButton(target: self, action: #selector(tappedViewCart))
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
         
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if  UserDefaults.standard.string(forKey: KeyUser.userType) == UserTypeEnum.store.rawValue{
            
            tableView.bottomAnchor.constraint(equalTo: lblTotal.topAnchor,constant: -15).isActive = true
        }else{
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -15).isActive = true
        }
        
        
    }
    
}

extension ProductController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.count > 0 {
            tableView.restore()
        }else{
            tableView.setEmptyView()
        }
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        
        cell.imgLogo.clipsToBounds = true
        cell.imgLogo.image =  product.photo.fromBase64String()
        cell.lblName.text = "Name: " + product.name
        cell.lblPrice.text = "Price: " + (product.price.twoDigit(sign: "$") )
        cell.lblStock.text = "Stock: " + product.stockQuantity.description
        
        if repeatingArray[indexPath.row].value {
            cell.imgCircle.image = .icTick
        }else{
            cell.imgCircle.image = UIImage()
        }
        
        if  UserDefaults.standard.string(forKey: KeyUser.userType) == UserTypeEnum.merchant.rawValue{
            cell.btnUpdate.isHidden = false
            cell.btnDelete.isHidden = false
            cell.imgCircle.isHidden = true
        }else{
            cell.btnUpdate.isHidden = true
            cell.btnDelete.isHidden = true
            cell.imgCircle.isHidden = false
        }
        
        cell.btnDelete.addTargetButton(target: self, action: #selector(didTappedDelete))
        cell.btnUpdate.addTargetButton(target: self, action: #selector(didTappedUpdate))
        cell.btnUpdate.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if  UserDefaults.standard.string(forKey: KeyUser.userType) == UserTypeEnum.store.rawValue{
            let product = products[indexPath.row]
            if product.stockQuantity > 0 {
                repeatingArray[indexPath.row].value.toggle()
            }else{
                AlertMessage.shared.alertError(title: "Message",message: "The product is out of stock.")
            }
        }

    }
    
    
    
    @objc func didTappedDelete(_ sender : UIButton) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Delete Product",
                                                message: "Are you sure you want to delete this product?",
                                                preferredStyle: .alert)
        
        // Add the "Cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // Handle the cancel action
            print("Cancel tapped")
            self.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        
        // Add the "OK" button
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // Handle the OK action
            print("OK tapped")
            self.dismiss(animated: true){ [self] in
                Loading.shared.showLoading()
                DatabaseManager().deleteProduct(byId: products[sender.tag].id )
                products = DatabaseManager().fetchProducts()
            }
        }
        
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    @objc func didTappedUpdate(_ sender: UIButton){
        
        let addProductVC = CreateAndUpdateProductController()
        addProductVC.isEnumCreateOrUpdate = .update
        addProductVC.product = products[sender.tag] // Product()
        navigationController?.pushViewController(addProductVC, animated: true)
        
    }
    
}
