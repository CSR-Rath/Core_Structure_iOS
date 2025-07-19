//
//  APITheSameTimeVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/7/25.
//

import UIKit

protocol RefreshController: AnyObject {
    func pullRefreshData()
}

class APITheSameTimeVC: UIViewController, RefreshController {
    
    private let tableView = UITableView()
    private let viewModel = APITheSameTimeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        
        
        viewModel.fetchUsersAndPosts()
        viewModel.onDataUpdated = {
            self.tableView.reloadData()
            self.tableView.isEndRefreshing()
            self.tableView.isHideLoadingSpinner()
        }
        
    }
    
    @objc internal func pullRefreshData() {
        tableView.isEndRefreshing()
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
    
}

extension APITheSameTimeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if tableView.isPagination(indexPath: indexPath, arrayCount: viewModel.users.count, totalItems: 1000){
//            
//        }
    }
}

extension APITheSameTimeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Two sections: users and posts
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.users.count
        } else {
            return viewModel.posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Users" : "Posts"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            let user = viewModel.users[indexPath.row]
            cell.textLabel?.text = user.name
        } else {
            let post = viewModel.posts[indexPath.row]
            cell.textLabel?.text = post.title
        }
        return cell
    }
}



