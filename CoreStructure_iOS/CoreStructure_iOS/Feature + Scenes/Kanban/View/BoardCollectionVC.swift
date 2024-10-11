//
//  BoardCollectionVC.swift
//  LOS
//
//  Created by Rath! on 11/9/24.
//

import UIKit
import MobileCoreServices

class BoardCollectionVC: UIViewController{

    private var collectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    
    var boards = [
        Board(title: "Data Entry",
              items: ["Database Migration",
                      "Schema Design",
                      "Storage Management",
                      "Model Abstraction"]),
        Board(title: "Verification",
              items: ["Push Notification",
                      "Analytics",
                      "Machine Learning"]),
        Board(title: "Analysts",
              items: ["System Architecture",
                      "Alert & Debugging"]),
        Board(title: "Apploval",
              items: ["System Architecture",
                      "Alert & Debugging"]),
        Board(title: "Disburment",
              items: ["System Architecture",
                      "Alert & Debugging"])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupAddButtonItem()
        setupCollectionView()
    }
    
    
   
    //MARK: when change screen Portrait or landscape
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionViewItem(with: size)

    }
    
    private func updateCollectionViewItem(with size: CGSize) {
        flowLayout.itemSize = CGSize(width: 300, height: size.height * 0.9)
    }
    
}

//MARK: DataSource CollectionView
extension BoardCollectionVC: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return boards.count
   }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BoardCollectionViewCell
       
       cell.board = boards[indexPath.item]
       cell.parentVC = self
       return cell
   }
}

//MARK: Setup Constraint CollectionView and itemSize
extension BoardCollectionVC{
    
    private func setupCollectionView() {
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: view.frame.height * 0.9)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 30
        // Initialize UICollectionView with the flow layout
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

//MARK: Handle button
extension BoardCollectionVC{
    
    func setupAddButtonItem() {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(addListTapped(_:)))
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    func setupRemoveBarButtonItem() {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addInteraction(UIDropInteraction(delegate: self))
        let removeBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = removeBarButtonItem
    }
    
    @objc private func addListTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else {
                return
            }
            
            self.boards.append(Board(title: text, items: []))
            let addedIndexPath = IndexPath(item: self.boards.count - 1, section: 0)
            
            self.collectionView.insertItems(at: [addedIndexPath])
            self.collectionView.scrollToItem(at: addedIndexPath, at: .centeredHorizontally, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

//MARK: Handle delete item on button delete
extension BoardCollectionVC: UIDropInteractionDelegate {

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            session.loadObjects(ofClass: NSString.self) { (items) in
                guard let _ = items.first as? String else {
                    return
                }
                
                //MARK: handle drop on delete item
                if let (dataSource, sourceIndexPath, tableView) = session.localDragSession?.localContext as? (Board, IndexPath, UITableView) {
                    tableView.beginUpdates()
                    dataSource.items.remove(at: sourceIndexPath.row)
                    tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }
        }
    }
}



