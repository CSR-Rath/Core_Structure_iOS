//
//  CollectionViewHandler.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/10/24.
//

import UIKit
import Combine

class CollectionViewHandler<CELL: UICollectionViewCell, T>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @Published var items: [T] = []
    private var cellIdentifier: String
    private var cellSize: CGSize?
    private var cancellables = Set<AnyCancellable>()
    
    var configureCell: (CELL, T, IndexPath) -> Void = { _, _, _ in }
    var selectedCell: (T) -> Void = { _ in }
    
    init(cellIdentifier: String, items: [T], cellSize: CGSize? = nil) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.cellSize = cellSize
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.item < items.count else {
            fatalError("Index out of range")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CELL
        configureCell(cell, items[indexPath.item], indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell(items[indexPath.item])
    }
    
    func updateItems(_ newItems: [T]) {
        self.items = newItems
    }
}
