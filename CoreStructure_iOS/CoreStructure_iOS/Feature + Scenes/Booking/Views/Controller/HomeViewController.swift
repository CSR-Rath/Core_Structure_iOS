//
//  HomeViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 3/12/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTitleNavigationBar(titleColor: .white, backColor: .mainBlueColor)
    }
    private func setupUI(){
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.backgroundColor = .clear
        
        cell.didSelectItemsCell = { index in
            self.handleCellSelection(index: index)
        }
        return cell
    }
    
    private func handleCellSelection(index: Int) {
        let vc: UIViewController
        
        switch index {
        case 0:
            
            Loading.shared.showLoading()
            vc = GeustsListController()
        case 1:
            
            Loading.shared.showLoading()
            vc = RoomListViewController()
        case 2:
            
            vc = ReservationViewController()
        default:
            
            Loading.shared.showLoading()
            vc = ReservationListViewController()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
