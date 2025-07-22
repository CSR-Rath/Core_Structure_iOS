//
//  APITheSameTimeVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/7/25.
//

import UIKit

class APITheSameTimeVC: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = APITheSameTimeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        
        Loading.shared.showLoading()
        viewModel.fetchApiTheSameTime()
        viewModel.onDataUpdated = {
            self.tableView.reloadData()
            self.tableView.isEndRefreshing()
            self.tableView.isHideLoadingSpinner()
            Loading.shared.hideLoading()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register a simple UITableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isAddRefreshControl(target: self, action: #selector(pullRefreshData))
    }
    
    @objc private func pullRefreshData() {
        viewModel.fetchApiTheSameTime()
    }
}

extension APITheSameTimeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView.isPagination(indexPath: indexPath,
                                  arrayCount: viewModel.productList1?.results?.count ?? 0,
                                  totalItems: viewModel.productList1?.count ?? 0){
            
        }
    }
}

extension APITheSameTimeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.productList1?.results?.count ?? 0 > 0{
            tableView.isRestoreEmptyState()
        }else{
            tableView.isShowEmptyState()
        }
        
        return viewModel.productList1?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.productList1?.results?[indexPath.row].name
        return cell
    }
}



