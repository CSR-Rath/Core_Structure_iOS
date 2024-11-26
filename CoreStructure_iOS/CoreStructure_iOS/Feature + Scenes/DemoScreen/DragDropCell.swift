//
//  DragDropCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/11/24.
//

import UIKit

class ViewControllerCell: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    var collectionView1: UICollectionView!
    var collectionView2: UICollectionView!
    var items1 = ["icBack", "icBack", "icBack"]
    var items2 = ["icClose", "icClose", "icClose"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange

        let layout1 = UICollectionViewFlowLayout()
        collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: layout1)
        collectionView1.backgroundColor = .white
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView1.dragDelegate = self
        collectionView1.dropDelegate = self
        collectionView1.dragInteractionEnabled = true
        collectionView1.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        let layout2 = UICollectionViewFlowLayout()
        collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        collectionView2.backgroundColor = .cyan
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.dragDelegate = self
        collectionView2.dropDelegate = self
        collectionView2.dragInteractionEnabled = true
        collectionView2.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        let stackView = UIStackView(arrangedSubviews: [collectionView1, collectionView2])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == collectionView1 ? items1.count : items2.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .lightGray

        // Remove any existing subviews
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView(frame: cell.contentView.frame)
        imageView.contentMode = .scaleAspectFit
        let imageName = collectionView == collectionView1 ? items1[indexPath.row] : items2[indexPath.row]
        imageView.image = UIImage(named: imageName)
        cell.contentView.addSubview(imageView)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = collectionView == collectionView1 ? items1[indexPath.row] : items2[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        coordinator.items.forEach { dropItem in
            if let sourceIndexPath = dropItem.sourceIndexPath {
                collectionView.performBatchUpdates({
                    if collectionView == collectionView1 {
                        let item = items2.remove(at: sourceIndexPath.row)
                        items1.insert(item, at: destinationIndexPath.row)
                    } else {
                        let item = items1.remove(at: sourceIndexPath.row)
                        items2.insert(item, at: destinationIndexPath.row)
                    }
                    collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                })
                coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
            } else {
                let placeholderContext = coordinator.drop(dropItem.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "placeholderCell"))
                dropItem.dragItem.itemProvider.loadObject(ofClass: NSString.self) { (item, error) in
                    DispatchQueue.main.async { [self] in
                        if let item = item as? String {
                            placeholderContext.commitInsertion { insertionIndexPath in
                                if collectionView == collectionView1 {
                                    self.items1.insert(item, at: insertionIndexPath.row)
                                } else {
                                    self.items2.insert(item, at: insertionIndexPath.row)
                                }
                            }
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
}
