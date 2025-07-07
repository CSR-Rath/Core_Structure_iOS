//
//  DynamicHeightVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 3/6/25.
//

import UIKit

class TwoColorsTopBottomVC: UIViewController {
    
    private var topHeightConstraint = NSLayoutConstraint()
    
    var contentOffset = 0.0
    
    private let viewTop: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    private let viewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    lazy var viewBotom: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [viewTop,viewBottom])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubview(viewBotom)
        view.addSubview(tableView)
        
        topHeightConstraint = viewTop.heightAnchor.constraint(equalToConstant: 0)
        topHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            viewBotom.topAnchor.constraint(equalTo: view.topAnchor),
            viewBotom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewBotom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewBotom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        let newHeight = max(150, 350 - contentOffset)
        
        if topHeightConstraint.constant != newHeight {
            topHeightConstraint.constant = newHeight
        }
    }
}

// MARK: UITableView Delegate & DataSource

extension TwoColorsTopBottomVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        cell.backgroundColor = .clear
        return cell
    }
}
