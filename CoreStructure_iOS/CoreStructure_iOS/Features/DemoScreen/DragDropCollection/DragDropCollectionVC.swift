//
//  ViewController.swift
//  DragDropCollectionView
//
//  Created by Rath! on 7/5/24.
//

import UIKit
enum MenuTitleEnum: String{
    case wallet = "Wallet"
    case reward = "Reward"
    case fun = "Fun"
    case offer = "Special Offer"
    case events = "Events"
    case charity = "Charity"
    case none = "none"
}

struct MenuListModel: Codable {
    let imageName: String
    let title: String
    let id: Int
}

class DragDropCollectionVC: BaseUIViewConroller,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UICollectionViewDragDelegate,
                            UICollectionViewDropDelegate {
    
    static let  cell = "MenuListDragDropCell"
    private var didSelectItemsCell : ((_ : MenuListModel)->())?
    private var isDraggingItem: Bool = false
    
    var collectionView : UICollectionView!
    
    private var dataList : [MenuListModel] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drag Drop CollectionView"
        setupCollectionView()
        loadDataList()
        setupLongPressGestureRecognizer()
    }
    
    //MARK: Set default date and fetching data
    func loadDataList() {
        
        let dateMenu =  StoreLocalDataManager.shared.getDragDropMenu() ?? []
        if  dateMenu.count > 0  {
            dataList = dateMenu
        }else{
            
            // Set default dataList if no saved data is found
            dataList = [
                MenuListModel(imageName: "", title: "Titem 1", id: 1),
                MenuListModel(imageName: "", title: "Titem 2", id: 2),
                MenuListModel(imageName: "", title: "Titem 3",  id: 3),
                MenuListModel(imageName: "", title: "Titem 4", id: 4),
                MenuListModel(imageName: "", title: "Titem 5", id: 5),
                MenuListModel(imageName: "", title: "Titem 6", id: 6)
            ]
            
            StoreLocalDataManager.shared.saveDragDropMenu(data: dataList)
        }
    }
    
}

extension DragDropCollectionVC{
    
    private func setupCollectionView() {
        
        let spacing = 15
        let size = ((Int(UIScreen.main.bounds.width)-32)-(spacing*2))/3
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = CGFloat(spacing)
        layout.minimumLineSpacing = CGFloat(spacing)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.register(MenuDragDropCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        collectionView.backgroundColor = .orange
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier",
                                                      for: indexPath) as! MenuDragDropCell
        
        let titleImageModel = dataList[indexPath.item]
        cell.imgIcon.image =  UIImage(named: titleImageModel.imageName)
        cell.titleLabel.text = titleImageModel.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        isDraggingItem = true
        UIDevice.generateButtonFeedback()
        
        let titleImageModel = dataList[indexPath.item]
        let itemProvider = NSItemProvider(object: titleImageModel.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = collectionView.cellForItem(at: indexPath)
        return [dragItem]
    }
    
    // MARK: - UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        print("canHandle")  // Check if this is being
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        let isLocalDrag = session.localDragSession != nil
        return UICollectionViewDropProposal(operation: isLocalDrag ? .move : .copy,
                                            intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("performDropWith")
        isDraggingItem = false
        
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath,
               let _ = item.dragItem.localObject as? MenuDragDropCell {
                collectionView.performBatchUpdates({
                    let movedItem = dataList.remove(at: sourceIndexPath.item)
                    dataList.insert(movedItem, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }, completion: { finished in
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                })
            }
        }
        
        StoreLocalDataManager.shared.saveDragDropMenu(data: dataList)
        UIDevice.generateButtonFeedback()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isDraggingItem{
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            pushVC(to: vc )
        }
    }
    
}

extension DragDropCollectionVC { // Prevents unmoved drag
    
    // MARK: - Setup Long Press Gesture Recognizer
    private func setupLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard collectionView.indexPathForItem(at: location) != nil else { return }
        
        switch gesture.state {
        case .began:
            
            break
            
        case .ended, .cancelled:
            
            isDraggingItem = false; print("ended , cancelled")
            
        default:
            break
        }
    }
    
}
