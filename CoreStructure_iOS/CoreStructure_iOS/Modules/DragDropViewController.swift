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
        return session.hasItemsConforming(toTypeIdentifiers: [UTType.text.identifier])
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



class GenerateQRCodeVC: UIViewController {
    
    // Define lazy views
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "The Real Reward".uppercased()
        label.fontBold(16)
        label.textColor = .white
        return label
    }()
    
    lazy var containerView: BlurredBackgroundView = {
        let view = BlurredBackgroundView()
        view.backgroundColor = .orange.withAlphaComponent(0.12)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var bgQRCode: UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .gray
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        return bgView
    }()
    
    lazy var imgQR: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setImageColor(color: .black)
        img.backgroundColor = .white
        img.layer.borderColor = UIColor.white.cgColor
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var bgQRCodeWhite: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var imgTheReal: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var btnCancel: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(.icClose, for: .normal)
        btn.addTarget(self, action: #selector(animateDismissView), for: .touchUpInside)
        return btn
    }()
    
    lazy var topLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var topQRCodeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    
    lazy var imgLogoTheRealLeft: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.setImageColor(color: .white)
        return img
    }()
    
    lazy var imgLogoTheRealRight: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.alpha = 0.25
        return img
    }()
    
    // Constants
    let defaultHeight: CGFloat = 466
    let dismissibleHeight: CGFloat = 336
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    var currentContainerHeight: CGFloat = 466
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    var containerReloading: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupConstraints()
        setupPanGesture()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func setupConstraints() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(bgQRCode)
        containerView.addSubview(btnCancel)
        containerView.addSubview(topLineView)
        bgQRCode.addSubview(topQRCodeView)
        bgQRCode.addSubview(bgQRCodeWhite)
        bgQRCodeWhite.addSubview(imgQR)
        bgQRCodeWhite.addSubview(imgTheReal)
        topQRCodeView.addSubview(titleLabel)
        topQRCodeView.addSubview(imgLogoTheRealRight)
        topQRCodeView.addSubview(imgLogoTheRealLeft)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgQRCode.heightAnchor.constraint(equalToConstant: 335),
            bgQRCode.widthAnchor.constraint(equalToConstant: 280),
            bgQRCode.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            btnCancel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            btnCancel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            btnCancel.heightAnchor.constraint(equalToConstant: 30),
            btnCancel.widthAnchor.constraint(equalToConstant: 30),
            topLineView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            topLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 5),
            topLineView.widthAnchor.constraint(equalToConstant: 36),
            topQRCodeView.heightAnchor.constraint(equalToConstant: 53),
            topQRCodeView.leftAnchor.constraint(equalTo: bgQRCode.leftAnchor),
            topQRCodeView.rightAnchor.constraint(equalTo: bgQRCode.rightAnchor),
            topQRCodeView.topAnchor.constraint(equalTo: bgQRCode.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: topQRCodeView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: topQRCodeView.rightAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topQRCodeView.centerYAnchor),
            bgQRCodeWhite.heightAnchor.constraint(equalToConstant: 213),
            bgQRCodeWhite.widthAnchor.constraint(equalToConstant: 209),
            bgQRCodeWhite.centerXAnchor.constraint(equalTo: bgQRCode.centerXAnchor),
            bgQRCodeWhite.centerYAnchor.constraint(equalTo: bgQRCode.centerYAnchor, constant: 26.5),
            imgQR.centerXAnchor.constraint(equalTo: bgQRCodeWhite.centerXAnchor),
            imgQR.centerYAnchor.constraint(equalTo: bgQRCodeWhite.centerYAnchor),
            imgQR.heightAnchor.constraint(equalToConstant: 145),
            imgQR.widthAnchor.constraint(equalToConstant: 145),
            imgTheReal.centerXAnchor.constraint(equalTo: bgQRCodeWhite.centerXAnchor),
            imgTheReal.centerYAnchor.constraint(equalTo: bgQRCodeWhite.centerYAnchor),
            imgTheReal.heightAnchor.constraint(equalToConstant: 50),
            imgTheReal.widthAnchor.constraint(equalToConstant: 50),
            imgLogoTheRealLeft.widthAnchor.constraint(equalToConstant: 36.5),
            imgLogoTheRealLeft.heightAnchor.constraint(equalToConstant: 29),
            imgLogoTheRealLeft.centerYAnchor.constraint(equalTo: topQRCodeView.centerYAnchor),
            imgLogoTheRealLeft.leftAnchor.constraint(equalTo: topQRCodeView.leftAnchor, constant: 10),
            imgLogoTheRealRight.bottomAnchor.constraint(equalTo: topQRCodeView.bottomAnchor),
            imgLogoTheRealRight.topAnchor.constraint(equalTo: topQRCodeView.topAnchor),
            imgLogoTheRealRight.rightAnchor.constraint(equalTo: topQRCodeView.rightAnchor),
        ])
        
        containerReloading = bgQRCode.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        containerReloading?.isActive = true
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newHeight = currentContainerHeight - translation.y
        let isDraggingDown = translation.y > 0
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                if newHeight < defaultHeight {
                    containerReloading?.isActive = false
                    containerReloading = bgQRCode.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 65)
                    containerReloading?.isActive = true
                } else {
                    containerReloading?.isActive = false
                    containerReloading = bgQRCode.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
                    containerReloading?.isActive = true
                }
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            isMax = false
            if newHeight < dismissibleHeight {
                animateDismissView()
            } else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            } else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            } else if newHeight > defaultHeight && !isDraggingDown {
                isMax = true
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        // Optionally animate showing a dimmed view
    }
    
    var isMax: Bool = false
    
    @objc func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            
            self.containerViewBottomConstraint?.constant = self.isMax ?  self.maximumContainerHeight : self.defaultHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.isMax = false
            self.dismiss(animated: false)
        }
    }
}
