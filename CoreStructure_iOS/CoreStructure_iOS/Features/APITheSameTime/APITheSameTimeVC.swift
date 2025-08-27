//
//  APITheSameTimeVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/7/25.
//

import UIKit
import Combine

class APITheSameTimeVC: BaseUIViewConroller {
    
    
    private let viewModel = APITheSameTimeViewModel()
    
    private let viewModelApi = ViewModel()
    
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title =  "Call Api The SameTime"
        leftBarButtonItem(icon: nil)
        view.backgroundColor = .white
        setupTableView()
        
        Loading.shared.showLoading()
        viewModelApi.asyncCall()
        viewModelApi.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
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
        tableView.addRefreshControl(target: self, action: #selector(pullRefreshData))
    }
    
    @objc private func pullRefreshData() {
        viewModelApi.asyncCall()
    }
    
}

extension APITheSameTimeVC: UITableViewDelegate {
    
}

extension APITheSameTimeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelApi.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModelApi.posts?[indexPath.row].title
        return cell
    }
    
}
