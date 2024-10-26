//
//  TableHandlerVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/10/24.
//

import UIKit
import Combine

class CustomTableViewCell: UITableViewCell {
    let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}



class CustomHeaderView: UIView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .lightGray // Set background color
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}


class TableHandlerVC: UIViewController {
    
    private let tableView = UITableView()
    /*private*/ var handleTableView: TableViewHandler<CustomTableViewCell, String>!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        

        
   
        handle()
        
        // Configure the table view
        setupTableView()
        
    }
    
    
    private func handle(){
        
        let i = Array(repeating: "1", count: 500)
        
        // Initialize the view model with multiple sections
        handleTableView = TableViewHandler<CustomTableViewCell, String>(
            cellIdentifier: "CustomTableViewCell",
            cellHeight: 30,
            sections: [
                i, // Section 0
                ["Item 2A", "Item 2B", "Item 2C"] // Section 1
            ]
        )
        
        
        // Configure the cell using a closure
        handleTableView.configureCell = { cell, item, indexPath in
            cell.textLabel?.text = item
            cell.animateScrollCell(index: indexPath.row)
        }
        
        // Configure the header using a closure
        handleTableView.configureHeader = { header, item, section in
            if let headerView = header as? CustomHeaderView {
                headerView.titleLabel.text = "Header for Section \(section + 1)"
            }
        }
        
        // Provide header height dynamically
        handleTableView.headerHeightForSection = { section in
            

            return 0
        }
        
        // Handle cell selection
        handleTableView.selectedCell = { item in
            print("Selected item: \(item)")
        }
        
        // Observe changes to sections
        handleTableView.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
            .store(in: &cancellables)
        
        // Example: Update items in a specific section dynamically after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.handleTableView.updateItems(inSection: 0, newItems: [])
            // Update items in section 1 as well
            self.handleTableView.updateItems(inSection: 1, newItems: [])
        }
    }
    
    private func setupTableView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.dataSource = handleTableView
        tableView.delegate = handleTableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        

        
        // Add the table view to the view hierarchy
        view.addSubview(tableView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add the refresh control
        tableView.addRefreshControl(target: self, action: #selector(didRefresh))
        
        
    }
    
    private func setup(){
        
    }
    
    @objc func didRefresh(){
        print("tesing ")
        
        
        self.handleTableView.updateItems(inSection: 0, newItems: [])
        // Update items in section 1 as well
        self.handleTableView.updateItems(inSection: 1, newItems: ["New Item 2A", "New Item 2B", "New Item 2C"])
        
        
    }
    
}
