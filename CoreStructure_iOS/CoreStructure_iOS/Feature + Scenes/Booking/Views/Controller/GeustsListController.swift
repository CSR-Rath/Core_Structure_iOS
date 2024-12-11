//
//  GuestsConteroller.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/12/24.
//

import UIKit

class GeustsListController: UIViewController {
    
    var guestsList : [Guest] = []{
        didSet{
            self.tableView.reloadData()
            Loading.shared.hideLoading()
        }
    }
    
    var didSelectRow:((Guest)->())?
    
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        Loading.shared.showLoading()
        GuestsViewModel.shared.getGuestsList { response in
            DispatchQueue.main.async {
                self.guestsList = response.results
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Guests"
        rightBarButton(action: #selector(didTappedRigth),iconButton: .icAdd)
        leftBarButton()
        self.setupTitleNavigationBar(titleColor: .white, backColor: .mainBlueColor)
    }
    
    
    private func setupUI(){
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.rowHeight = 90
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
    }
    
    @objc func didTappedRigth(){
        let vc = GeustController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension GeustsListController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if guestsList.count > 0{
            tableView.restore()
        }else{
            tableView.setEmptyView()
        }
        
        return guestsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        
        let data = guestsList[indexPath.row]
        
        cell.lblPrice.text = "Name: \(data.firstName + data.firstName) \t\t\t DI: \(data.id)"
        cell.lblName.text = "Phone Number: \(data.phone)"
        cell.lblDate.text = data.email
        
        cell.lblPrice.fontMedium(16)
        cell.lblName.fontMedium(16)
        
        cell.lblDate.textColor = .red.withAlphaComponent(0.3)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectRow?(guestsList[indexPath.row])
    }
}
