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

class HomeABAVC: BaseUIViewConroller, UIScrollViewDelegate{
    
    let text = UILabel()
    var didScrollView: ((_ : UIScrollView)->())?
    
    private let spacing: CGFloat = 10
    private let radius: CGFloat = 15
    
    private var isRepeating = false
    private var isDraggingTableView: Bool = false
    private var isDraggingCollectView: Bool = false
    private var isHasAnimateDraging: Bool = false
    private let colorCollectionView: UIColor = .clear
    private var indexDraging: Int? = nil{
        didSet{
            tableView.reloadData()
        }
    }
    
    private var data1: [ItemDragDropModel] = []{
        didSet{
//            print("Change data1")
            StoreLocalDataManager.shared.saveItemOneDropModel(data: data1)
            collectionView1.reloadData()
        }
    }
    
    private var data2: [ItemDragDropModel] = []{
        didSet{
//            print("Change data2")
            StoreLocalDataManager.shared.saveItemTwoDropModel(data: data2)
            collectionView2.reloadData()
        }
    }
    
    private var dataListTable = [
        [ "Item 1-1"],
        [ "Item 2-1","Item 2-2"]
    ]
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.backgroundColor = .clear
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true // Required for refresh to show
        scroll.addRefreshControl(target: self, action: #selector(pullRefresh))
        return scroll
    }()
    
    lazy var viewCard: UIView = {
        let view = UIView()
        view.alpha = 0.85
        view.layer.cornerRadius = radius
        view.backgroundColor = .mainBGColor
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
        collectionView.roundCorners(corners: [.topLeft, .topRight], radius: radius)
        return collectionView
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
        collectionView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
        return collectionView
    }()
    
    lazy var tableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
       
        tableView.register(TableCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.isScrollEnabled = false
        tableView.dragInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var viewLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = spacing
        view.backgroundColor = .red
        return view
    }()
    
    lazy var stackContainer: UIStackView = {
        // Nested stack that gets margins
        let topStack = UIStackView(arrangedSubviews: [
            viewCard,
            collectionView1,
            collectionView2
        ])
        topStack.axis = .vertical
        topStack.spacing = 15
        topStack.alignment = .fill
        topStack.distribution = .fill
        topStack.layoutMargins = UIEdgeInsets(top: .mainLeft,
                                              left: .mainLeft,
                                              bottom: 0,
                                              right: .mainLeft)
        topStack.isLayoutMarginsRelativeArrangement = true
        topStack.setCustomSpacing(0, after: collectionView1)
        
        // Main stack
        let stack = UIStackView(arrangedSubviews: [
            topStack,
            tableView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .mainLeft
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = .clear

        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UI ABA Drag Drop"
        setupData()
        seupConstraints()
        setupLongPressGestureRecognizers()
    }
    
}


// MARK: - Handle action go to new view controller
extension HomeABAVC {
    
    private func didTappedOnNotification(){
        
    }
    
    private func didSelectionCellTableViewRow(id: Int){
        
    }
    
    private func didSelectionCellCollectionViewItems(id: Int){
         
    }
    
}


extension HomeABAVC {
    
    @objc private func pullRefresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.scrollView.stopRefreshing()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollView?(scrollView)
    }
}


//MARK: - Prevents unmoved drag
extension HomeABAVC {
    
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
    
    // MARK: - Handle Long Press Gesture privent, user drag, but no drop or only animate drag
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            // Handle the beginning of the long press, e.g., start a drag
            print("Long press began")
            UIDevice.generateButtonFeedback(style: .medium)
            
            
        case .ended, .cancelled:
            // Handle the end or cancellation of the gesture, e.g., end a drag
            
            dragDropTableView(status: true)
            dragDropCollection(status: true)
            print("Long press ended or cancelled")
            
            isDraggingCollectView = false
            
            if isDraggingTableView {
                isDraggingTableView = false
            }
            
        default:
            break
        }
        
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate
extension HomeABAVC:  UITableViewDataSource,
                      UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataListTable.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataListTable[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        let title = dataListTable[indexPath.section][indexPath.row]
        
        cell.configure(title: title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let data =  dataListTable[indexPath.section][indexPath.row]
        
        didSelectionCellTableViewRow(id: 1)
        print("UITableView didSelectRowAt")
    }
    
}

// MARK: - UITableViewDragDelegate & UITableViewDropDelegate
extension HomeABAVC: UITableViewDragDelegate,
                     UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        isDraggingTableView = true
        dragDropCollection(status: false)

        print("itemsForBeginning tableView")
        
        let item = dataListTable[indexPath.section][indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableCell else {
            return nil
        }
        let parameters = UIDragPreviewParameters()
        
        // Use viewBg frame to clip drag preview with rounded corners
        let bgFrame = cell.viewBg.frame
        parameters.visiblePath = UIBezierPath(roundedRect: bgFrame,
                                              cornerRadius: cell.viewBg.layer.cornerRadius)
        
        // Optional: make preview background transparent
        parameters.backgroundColor = cell.viewBg.backgroundColor
        
        return parameters
    }
    
    // MARK: Drop Delegate
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        isDraggingTableView = false
        dragDropCollection(status: true)
        print("performDropWith tableView")
        
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
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession,
                   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        print("dragSessionDidEnd tableView")
        UIDevice.generateButtonFeedback(style: .medium)

    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate and UICollectionViewDelegateFlowLayout
extension HomeABAVC:  UICollectionViewDataSource,
                      UICollectionViewDelegate,
                      UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == collectionView1 ? data1.count : data2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        
        let item: ItemDragDropModel
        if collectionView == collectionView1 {
            item = data1[indexPath.row]
        } else {
            item = data2[indexPath.row]
        }
        cell.titleLabel.text = item.name
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionView1{
            
            let size : CGFloat = (collectionView1.frame.width - (spacing * 2) - (2 * spacing))/3
            return CGSize(width: size, height: size*0.9)
            
        }
        else{
            
            let label = UILabel()
            label.fontBold(16)
            label.text = data2[indexPath.item].name
            let with = label.getFittedWidth() + 32
            
            return CGSize(width: with, height: 39)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data: ItemDragDropModel
        if collectionView == collectionView1 {
            data = data1[indexPath.row]
        } else {
            data = data2[indexPath.row]
        }
        
        didSelectionCellCollectionViewItems(id: data.id)
        print("didSelectItemAt")
        
    }
}

// MARK: - UICollectionViewDragDelegate, UICollectionViewDropDelegate
extension HomeABAVC: UICollectionViewDragDelegate,
                     UICollectionViewDropDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        print("itemsForBeginning")
        isDraggingCollectView = true
        dragDropTableView(status: false)
        UIDevice.generateButtonFeedback(style: .medium)
        
        // Get the ItemDropModel
        let item = collectionView == collectionView1 ? data1[indexPath.row] : data2[indexPath.row]
        
        let itemProvider = NSItemProvider(object: item.name as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = (collectionView, indexPath)
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        
        print("dragPreviewParametersForItemAt")
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell else {
            return nil
        }
        
        
        let parameters = UIDragPreviewParameters()
        
        // Use cell.viewBg to define the visible preview area
        let bgFrame = cell.viewBg.frame
        parameters.visiblePath = UIBezierPath(roundedRect: bgFrame,
                                              cornerRadius: cell.viewBg.layer.cornerRadius)
        
        // Optional: match background color to viewBg
        parameters.backgroundColor = cell.viewBg.backgroundColor
        
        return parameters
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        print("performDropWith collectionView")
        isDraggingCollectView = false
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
        }
        else if sourceCollectionView == collectionView && collectionView == collectionView2 {
            data2.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        }
        else if sourceCollectionView == collectionView1 && collectionView == collectionView2 {
            let temp = data1[sourceIndexPath.row]
            data1[sourceIndexPath.row] = data2[destinationIndexPath.row]
            data2[destinationIndexPath.row] = temp
        }
        else if sourceCollectionView == collectionView2 && collectionView == collectionView1 {
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
        UIDevice.generateButtonFeedback(style: .medium)
    }
    
    
}

extension HomeABAVC{
    
    private func configureCommonProperties(for collectionView: UICollectionView) {
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .gray.withAlphaComponent(0.8)//colorCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.clipsToBounds = true
        collectionView.dragInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func seupConstraints(){
        configureCommonProperties(for: collectionView1)
        configureCommonProperties(for: collectionView2)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackContainer)
        
        NSLayoutConstraint.activate([
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            
            stackContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            stackContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
        ])
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "UI ABA"
        text.fontBold(25, color: .black)
        
        
        scrollView.addSubview(viewLine)
        viewCard.addSubview(text)
        
        NSLayoutConstraint.activate([
            viewCard.heightAnchor.constraint(equalToConstant: 150),
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
        
        let getData1 = StoreLocalDataManager.shared.getItemOneDropModel()
        let getData2 = StoreLocalDataManager.shared.getItemTwoDropModel()
        
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
