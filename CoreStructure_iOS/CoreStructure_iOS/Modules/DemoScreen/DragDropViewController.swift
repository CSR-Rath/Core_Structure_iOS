//
//  DragDropViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 15/1/25.
//

import UIKit
import UniformTypeIdentifiers

struct ItemDropModel: Codable{
    var id: Int
    var name: String
    var iconName: String
    var description: String
}


class DragDropViewController: UIViewController,
                              UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDragDelegate,
                              UICollectionViewDropDelegate {
    
    var collectionView1: UICollectionView!
    var collectionView2: UICollectionView!
    
    
    private var data1: [ItemDropModel] = []{
        didSet{
            DataManager.shared.saveItemOneDropModel(data: data1)
            print("Change data1")
            collectionView1.reloadData()
        }
    }
    
    private var data2: [ItemDropModel] = []{
        didSet{
            DataManager.shared.saveItemTwoDropModel(data: data2)
            print("Change data2")
            collectionView2.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionViews()
        setupdata()
    }
    
    private func setupdata(){
        // handle data
        
        let getData1 = DataManager.shared.getItemOneDropModel()
        let getData2 = DataManager.shared.getItemTwoDropModel()
        
        if getData1?.count ?? 0 > 0 && getData2?.count ?? 0 > 0 {
            
            data1 = getData1!
            data2 = getData2!
            
        }else{
            data1 = [
                ItemDropModel(id: 1, name: "Item 1", iconName: "icon1", description: "Description for Item 1"),
                ItemDropModel(id: 2, name: "Item 2", iconName: "icon2", description: "Description for Item 2"),
                ItemDropModel(id: 3, name: "Item 3", iconName: "icon3", description: "Description for Item 3")
            ]
            
            data2 = [
                ItemDropModel(id: 4, name: "Item A", iconName: "iconA", description: "Description for Item A"),
                ItemDropModel(id: 5, name: "Item B", iconName: "iconB", description: "Description for Item B"),
                ItemDropModel(id: 6, name: "Item C", iconName: "iconC", description: "Description for Item C"),
                ItemDropModel(id: 7, name: "Item D", iconName: "iconA", description: "Description for Item A"),
                ItemDropModel(id: 8, name: "Item E", iconName: "iconB", description: "Description for Item B"),
                ItemDropModel(id: 9, name: "Item F", iconName: "iconC", description: "Description for Item C")
            ]
        }
    }
    
    // MARK: - Setup Collection Views
    private func setupCollectionViews() {
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.itemSize = CGSize(width: 100, height: 100)
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        
        collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: layout1)
        collectionView1.backgroundColor = .systemGray6
        collectionView1.isScrollEnabled = false
        collectionView1.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView1.dragDelegate = self
        collectionView1.dropDelegate = self
        collectionView1.dataSource = self
        collectionView1.delegate = self
        collectionView1.dragInteractionEnabled = true
        collectionView1.showsHorizontalScrollIndicator = false
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.itemSize = CGSize(width: 100, height: 50)
        layout2.minimumLineSpacing = 20
        layout2.minimumInteritemSpacing = 10
        
        collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        collectionView2.backgroundColor = .systemGray5
        collectionView2.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView2.dragDelegate = self
        collectionView2.dropDelegate = self
        collectionView2.dataSource = self
        collectionView2.delegate = self
        collectionView2.dragInteractionEnabled = true
        collectionView2.showsHorizontalScrollIndicator = false
        collectionView2.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        
        // Add to view and set constraints
        view.addSubview(collectionView1)
        view.addSubview(collectionView2)
        
        collectionView1.translatesAutoresizingMaskIntoConstraints = false
        collectionView2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView1.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView2.topAnchor.constraint(equalTo: collectionView1.bottomAnchor, constant: 20),
            collectionView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView2.heightAnchor.constraint(equalToConstant: 80)
        ])
        
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == collectionView1 ? data1.count : data2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 10
        
        
        let item: ItemDropModel
        if collectionView == collectionView1 {
            item = data1[indexPath.row]
        } else {
            item = data2[indexPath.row]
        }
        
        // Add label to display item name
        let label = UILabel(frame: cell.bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.text = item.name
        
        // Remove previous subviews to avoid duplication
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(label)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: ItemDropModel
        if collectionView == collectionView1 {
            item = data1[indexPath.row]
        } else {
            item = data2[indexPath.row]
        }
        
        print("item ==>", item)
    }
    
    // MARK: - UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        UIDevice.generateButtonFeedback(style: .medium)
        print("itemsForBeginning")
        
        // Get the ItemDropModel
        let item = collectionView == collectionView1 ? data1[indexPath.row] : data2[indexPath.row]
        
        // Use the `name` property as the NSItemProvider object
        let itemProvider = NSItemProvider(object: item.name as NSString)
        
        // Attach the full `ItemDropModel` as the local object for drag-and-drop operations
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = (collectionView, indexPath)
        
        return [dragItem]
    }
    
    // MARK: - UICollectionViewDropDelegate
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let item = coordinator.items.first else { return }
        guard let (sourceCollectionView, sourceIndexPath) = item.dragItem.localObject as? (UICollectionView, IndexPath) else { return }
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        
        // Ensure source and destination indices are valid
        if sourceCollectionView == collectionView1 {
            guard sourceIndexPath.row >= 0 && sourceIndexPath.row < data1.count else { return }
        } else if sourceCollectionView == collectionView2 {
            guard sourceIndexPath.row >= 0 && sourceIndexPath.row < data2.count else { return }
        }
        
        if collectionView == collectionView1 {
            guard destinationIndexPath.row >= 0 && destinationIndexPath.row <= data1.count else { return }
        } else if collectionView == collectionView2 {
            guard destinationIndexPath.row >= 0 && destinationIndexPath.row <= data2.count else { return }
        }
        
        // Swap Logic
        if sourceCollectionView == collectionView && collectionView == collectionView1 {
            data1.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        } else if sourceCollectionView == collectionView && collectionView == collectionView2 {
            data2.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        } else if sourceCollectionView == collectionView1 && collectionView == collectionView2 {
            let temp = data1[sourceIndexPath.row]
            data1[sourceIndexPath.row] = data2[destinationIndexPath.row]
            data2[destinationIndexPath.row] = temp
        } else if sourceCollectionView == collectionView2 && collectionView == collectionView1 {
            let temp = data2[sourceIndexPath.row]
            data2[sourceIndexPath.row] = data1[destinationIndexPath.row]
            data1[destinationIndexPath.row] = temp
        }
        
        sourceCollectionView.reloadItems(at: [sourceIndexPath])
        collectionView.reloadItems(at: [destinationIndexPath])
        
        print("performDropWith")
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        print("canHandle")
        if #available(iOS 14.0, *) {
            return session.hasItemsConforming(toTypeIdentifiers: [UTType.text.identifier])
        } else {
            // Fallback on earlier versions
            return  false//session.hasItemsConforming(toTypeIdentifiers: [UTType.text.identifier])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        print("dropSessionDidUpdate")
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
}



import UIKit

// Define a model to represent the items
struct Item {
    let name: String
    var isSelected: Bool
}

class MultiSelectTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var items: [Item] = [
        Item(name: "Item 1", isSelected: false),
        Item(name: "Item 2", isSelected: false),
        Item(name: "Item 3", isSelected: false),
        Item(name: "Item 4", isSelected: false),
        Item(name: "Item 5", isSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        // Initialize the table view
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.allowsMultipleSelection = true // Enable multiple selection
        self.view.addSubview(tableView)
    }
    
    // MARK: - Table View Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        
        // Set background color based on the `isSelected` property
        cell.contentView.backgroundColor = item.isSelected ? .lightGray : .white
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GenerateQRCodeVC()
        vc.transitioningDelegate = presentVC
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
   
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
    
    func printSelectedItems() {
        // Get all selected item names
        let selectedNames = items.filter { $0.isSelected }.map { $0.name }
        print("Selected items: \(selectedNames)")
    }
}




