//
//  TableViewHelper.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 30/6/25.
//

import UIKit

class TableViewManagerHelper<T: Codable>: NSObject,
                                          UITableViewDelegate,
                                          UITableViewDataSource {

    private var items: [T]
    private let cellIdentifier: String
    private let configureCell: (UITableViewCell, T) -> Void
    private let didSelect: (T) -> Void

    init(cellIdentifier: String,
         items: [T],
         configureCell: @escaping (UITableViewCell, T) -> Void,
         didSelect: @escaping (T) -> Void) {
        
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
        self.didSelect = didSelect
    }

    func updateItems(_ newItems: [T]) {
        self.items = newItems
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
        let item = items[indexPath.row]
        configureCell(cell, item)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelect(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct ProductModel: Codable {
    let name: String
    let price: Double
}



class ProductListViewController: UIViewController {

    private let tableView = UITableView()
    private var helper: TableViewManagerHelper<ProductModel>?
    
    var  items:[ProductModel] = [] {
        didSet{
            setupTableHelper(with: items)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
       
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }

    private func setupTableHelper(with products: [ProductModel]) {
        helper = TableViewManagerHelper<ProductModel>(
            cellIdentifier: "cell",
            items: products,
            configureCell: { cell, product in
                cell.textLabel?.text = "\(product.name) - $\(product.price)"
            },
            didSelect: { product in
                print("Selected: \(product.name)")
            }
        )

        tableView.dataSource = helper
        tableView.delegate = helper
        tableView.reloadData()
    }
}
