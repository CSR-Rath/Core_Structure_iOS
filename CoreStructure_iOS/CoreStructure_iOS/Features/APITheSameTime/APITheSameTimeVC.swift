//
//  APITheSameTimeVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/7/25.
//

import UIKit

class APITheSameTimeVC: BaseInteractionViewController {
    
    
    private let viewModel = APITheSameTimeViewModel()
    
    private let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title =  "Call Api The SameTime"
        leftBarButtonItem(icon: nil)
        view.backgroundColor = .white
        setupTableView()
        
        Loading.shared.showLoading() // Show loading before fetch

        viewModel.onDataUpdated = { [weak self] in
            guard let self else { return }

            print("✅ Data updated callback fired — all APIs done")

            self.tableView.reloadData()
            self.tableView.stopRefreshing()
            self.tableView.isHideLoadingSpinner()
            Loading.shared.hideLoading()
        }

        viewModel.fetchApiTheSameTime()
    }

    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register a simple UITableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.addRefreshControl(target: self, action: #selector(pullRefreshData))
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



