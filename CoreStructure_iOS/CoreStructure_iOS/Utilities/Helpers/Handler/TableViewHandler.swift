//
//  TableViewHandler.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/10/24.
//


import UIKit
import Combine

class TableViewHandler<CELL: UITableViewCell, T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    @Published var sections: [[T]] = [] // Array of arrays for multiple sections
    private var cellIdentifier: String
    private var cellHeight: CGFloat?
    private var cancellables = Set<AnyCancellable>()
    
    private var itemsCount: Int = 0
    
    var configureCell: (CELL, T, IndexPath) -> Void = { _, _, _ in }
    var configureHeader: (UIView, T, Int) -> Void = { _, _, _ in } // Closure to configure header
    var headerHeightForSection:  (Int) -> CGFloat = { _ in 0.0 } // Closure to provide header height
    var selectedCell: (T) -> Void = { _ in }
    var didDelectCell: (T,IndexPath) -> Void = { _, _ in }
    
    init(cellIdentifier: String,cellHeight: CGFloat? = nil, sections: [[T]] ) {
        self.cellIdentifier = cellIdentifier
        self.cellHeight = cellHeight
        self.sections = sections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sections.count > 0 {
            tableView.restore()
        }else{
            tableView.setEmptyListView()
        }
        
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < sections.count, indexPath.row < sections[indexPath.section].count else {
            fatalError("Index out of range")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        configureCell(cell, sections[indexPath.section][indexPath.row], indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell(sections[indexPath.section][indexPath.row])
        
        didDelectCell(sections[indexPath.section][indexPath.row],indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomHeaderView() // Create a new header view
        let item = sections[section].first ?? "" as! T // Assuming T is convertible to String for demo
        
        // Configure the header using the closure
        configureHeader(headerView, item, section)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return headerHeightForSection(section)  // Get height from closure
    }
    
    func updateItems(inSection section: Int, newItems: [T]) {
        guard section < sections.count else { return }
        sections[section] = newItems
    }
}



