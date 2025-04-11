//
//  DragDropViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 15/1/25.
//

import UIKit
import UniformTypeIdentifiers


struct ItemDragDropModel: Codable{
    var id: Int
    var name: String
    var iconName: String
    var description: String
}

class HomeABAViewController: UIViewController, UIGestureRecognizerDelegate{
    
    let text = UILabel()
    
   
    private var isDragging: Bool = false
    private let spacing: CGFloat = 10
    private let radius: CGFloat = 15

    private var data1: [ItemDragDropModel] = []{
        didSet{
            DataManager.shared.saveItemOneDropModel(data: data1)
            print("Change data1")
            collectionView1.reloadData()
        }
    }
    
    private var data2: [ItemDragDropModel] = []{
        didSet{
            DataManager.shared.saveItemTwoDropModel(data: data2)
            print("Change data2")
            collectionView2.reloadData()
        }
    }
    
    private var dataListTable = [
        [ "Item 2-1", "Item 2-2", "Item 2-3", "Item 2-4", "Item 2-5", "Item 2-6", "Item 2-7", "Item 2-8", "Item 2-9", "Item 2-10"]
    ]
    
    
   private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .white
        return scroll
    }()
    
    lazy var viewCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = radius
        view.backgroundColor = .systemGray6
        return view
    }()
    
    lazy var collectionView1: ContentSizedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: spacing,
                                           left: spacing,
                                           bottom: spacing,
                                           right: spacing)
        
        let collectionView = ContentSizedCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .systemGray6
        collectionView.isScrollEnabled = false
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.roundCorners(corners: [.topLeft, .topRight], radius: radius)
        
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    lazy var viewLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = spacing
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: spacing,
                                           left: spacing,
                                           bottom: spacing,
                                           right: spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .systemGray6
        collectionView.isScrollEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
        return collectionView
    }()
    
    lazy var tableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TableCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        return tableView
    }()
    
    lazy var stackContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            viewCard,
            collectionView1,
            collectionView2,
            tableView,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: .mainLeft,
                                           left: .mainLeft,
                                           bottom: .mainLeft,
                                           right: .mainLeft)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fill
        stack.setCustomSpacing(0, after: collectionView1)
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupData()
        seupConstraints()
        setupLongPressGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationBarAppearance(titleColor: .black,
                                     barAppearanceColor: .white,
                                     shadowColor: .clear)
    }

}

extension HomeABAViewController{
    
    private func seupConstraints(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackContainer)
        
        // MARK: - Main container
        NSLayoutConstraint.activate([
            
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            
            stackContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            stackContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
        ])
        
        // MARK: - Items in Scrollview
        
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "UI ABA"
        text.fontBold(25, color: .black)

        
        scrollView.addSubview(viewLine)
        viewCard.addSubview(text)
        
        NSLayoutConstraint.activate([
            viewCard.heightAnchor.constraint(equalToConstant: 200),
            collectionView2.heightAnchor.constraint(equalToConstant: 60),
            
            viewLine.heightAnchor.constraint(equalToConstant: 1),
            viewLine.centerYAnchor.constraint(equalTo: collectionView2.topAnchor),
            viewLine.leftAnchor.constraint(equalTo: collectionView2.leftAnchor, constant: .mainLeft),
            viewLine.rightAnchor.constraint(equalTo: collectionView2.rightAnchor, constant: .mainRight),
            
            text.centerYAnchor.constraint(equalTo: viewCard.centerYAnchor),
            text.centerXAnchor.constraint(equalTo: viewCard.centerXAnchor),
            
        ])
    }
    
    private func setupData() {
        
        let getData1 = DataManager.shared.getItemOneDropModel()
        let getData2 = DataManager.shared.getItemTwoDropModel()
        
        if let data1Items = getData1, let data2Items = getData2, data1Items.count > 0, data2Items.count > 0 {
            data1 = data1Items
            data2 = data2Items
        } else {
            
            data1 = [
                ItemDragDropModel(id: 1, name: "Item 1", iconName: "icon1", description: "Description for Item 1"),
                ItemDragDropModel(id: 2, name: "Item 2", iconName: "icon2", description: "Description for Item 2"),
                ItemDragDropModel(id: 3, name: "Item 3", iconName: "icon3", description: "Description for Item 3"),
                ItemDragDropModel(id: 4, name: "Item 4", iconName: "icon1", description: "Description for Item 4"),
                ItemDragDropModel(id: 5, name: "Item 5", iconName: "icon2", description: "Description for Item 5"),
                ItemDragDropModel(id: 6, name: "Item 6", iconName: "icon3", description: "Description for Item 6"),
                ItemDragDropModel(id: 7, name: "Item A", iconName: "iconA", description: "Description for Item A"),
                ItemDragDropModel(id: 8, name: "Item B", iconName: "iconB", description: "Description for Item B"),
                ItemDragDropModel(id: 9, name: "Item C", iconName: "iconC", description: "Description for Item C"),
            ]
            
            data2 = [
                ItemDragDropModel(id: 10, name: "Item D", iconName: "iconA", description: "Description for Item D"),
                ItemDragDropModel(id: 11, name: "Item E", iconName: "iconB", description: "Description for Item E"),
                ItemDragDropModel(id: 12, name: "Item F", iconName: "iconC", description: "Description for Item F"),
                ItemDragDropModel(id: 13, name: "Item G", iconName: "iconA", description: "Description for Item G"),
                ItemDragDropModel(id: 14, name: "Item H", iconName: "iconB", description: "Description for Item H"),
                ItemDragDropModel(id: 15, name: "Item I", iconName: "iconC", description: "Description for Item I"),
            ]
            
        }
    }
    
    private func dragDropCollection(status: Bool){
        collectionView1.dragDelegate = status ? self : nil
        collectionView1.dropDelegate = status ? self : nil
        
        collectionView2.dragDelegate = status ? self : nil
        collectionView2.dropDelegate = status ? self : nil
    }
    
    private func dragDropTableView(status: Bool){
        tableView.dragDelegate = status ? self : nil
        tableView.dropDelegate = status ? self : nil
    }
    
}



extension HomeABAViewController { // Prevents unmoved drag
    
    // MARK: - Setup Long Press Gesture Recognizers
    private func setupLongPressGestureRecognizers() {
        /*
         need call it again in dragSessionDidEnd,
         if you isn't call again it have small issue in case longPressGesture func it working,
         but itemsForBeginning isn't working,
         we using longPressGesture because prevent when dragging have another action
        */
        
        let longPressGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView1.addGestureRecognizer(longPressGesture1)
        
        let longPressGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView2.addGestureRecognizer(longPressGesture2)
        
        let longPressGesture3 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        tableView.addGestureRecognizer(longPressGesture3)
    }

    // MARK: - Handle Long Press Gesture
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {

        switch gesture.state {
        case .began:
            // Handle the beginning of the long press, e.g., start a drag
            print("Long press began")
            
        case .ended, .cancelled:
            // Handle the end or cancellation of the gesture, e.g., end a drag
            isDragging = false
            dragDropTableView(status: true)
            dragDropCollection(status: true)
            print("Long press ended or cancelled")
            
        default:
            break
        }
    }
}

//MARK: - UICollectionView
extension HomeABAViewController:  UICollectionViewDataSource,
                                  UICollectionViewDelegate,
                                  UICollectionViewDelegateFlowLayout,
                                  UICollectionViewDragDelegate,
                                  UICollectionViewDropDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == collectionView1 ? data1.count : data2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 15
        
        let item: ItemDragDropModel
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

        print("didSelectItemAt")
        
    }
    
    //UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionView1{
            
            let size : CGFloat = (collectionView1.frame.width - (spacing * 2) - (2 * spacing))/3
            return CGSize(width: size, height: size*0.9)
            
        }
        else{
            
            let label = UILabel()
            label.fontBold(16)
            label.text = data2[indexPath.item].name
            let with = label.getFittedWidth() + 20.0
            
            return CGSize(width: with, height: 39)
        }
        
    }

    // UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        isDragging = true
        dragDropTableView(status: false)
        UIDevice.shared.generateButtonFeedback(style: .medium)
        
        // Get the ItemDropModel
        let item = collectionView == collectionView1 ? data1[indexPath.row] : data2[indexPath.row]
        
        let itemProvider = NSItemProvider(object: item.name as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = (collectionView, indexPath)
        
        return [dragItem]
    }
    
    // UICollectionViewDropDelegate
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        print("performDropWith collectionView")
        isDragging = false
        dragDropTableView(status: true)
       
        
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {

        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        print("dragSessionDidEnd collectionView ")
        UIDevice.shared.generateButtonFeedback(style: .medium)
        setupLongPressGestureRecognizers()
    }
    
}

//MARK: - UITableView
extension HomeABAViewController:  UITableViewDataSource,
                                  UITableViewDelegate,
                                  UITableViewDragDelegate,
                                  UITableViewDropDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataListTable.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataListTable[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .red
        cell.textLabel?.text = dataListTable[indexPath.section][indexPath.row]
        return cell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        isDragging = true
        dragDropCollection(status: false)
        print("itemsForBeginning tableView")
        
        let item = dataListTable[indexPath.section][indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item

        return [dragItem]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        isDragging = false
        dragDropCollection(status: true)
        print(" performDropWith tableView")
      
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            print("No destination index path.")
            return
        }

        if let sourceIndexPath = coordinator.items.first?.sourceIndexPath {

            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                guard items is [String] else { return }

                tableView.performBatchUpdates({
                    let movedItem = self.dataListTable[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                    self.dataListTable[destinationIndexPath.section].insert(movedItem, at: destinationIndexPath.row)
                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                }, completion: { _ in
                    coordinator.drop(coordinator.items.first!.dragItem, toRowAt: destinationIndexPath)
                })
            }
        } else {
            print("No source index path.")
        }
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move,
                                       intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd: UIDragSession) {
        print("dragSessionDidEnd tableView")
        UIDevice.shared.generateButtonFeedback(style: .medium)
        setupLongPressGestureRecognizers()
    }

}




class TableCell: UITableViewCell{
    
    lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.alpha = 0
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubviews(of: viewBg)
        
        NSLayoutConstraint.activate([
        
            viewBg.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            viewBg.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewBg.topAnchor.constraint(equalTo: topAnchor),
            viewBg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            viewBg.heightAnchor.constraint(equalToConstant: 120),
        
        ])
    }
}
