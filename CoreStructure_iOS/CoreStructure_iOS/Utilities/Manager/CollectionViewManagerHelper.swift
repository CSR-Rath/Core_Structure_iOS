//
//  CollectionViewManagerHelper.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 30/6/25.
//

import UIKit

class CollectionViewManagerHelper<T: Codable>: NSObject,
                                               UICollectionViewDelegate,
                                               UICollectionViewDataSource,
                                               UICollectionViewDelegateFlowLayout {

    private var items: [T]
    private let configureCell: (UICollectionViewCell, T) -> Void
    private let didSelect: (T) -> Void
    private let cellIdentifier: String
    private let cellSize: CGSize

    init(items: [T],
         spacing: CGFloat = 10,
         cellIdentifier: String,
         cellSize: CGSize,
         configureCell: @escaping (UICollectionViewCell, T) -> Void,
         didSelect: @escaping (T) -> Void) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellSize = cellSize
        self.configureCell = configureCell
        self.didSelect = didSelect
    }

    func updateItems(_ newItems: [T]) {
        self.items = newItems
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
//        if items.count > 0 {
//            collectionView.isrestore()
//        }else{
//            collectionView.isEmptyListView()
//        }
        
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath)
        let item = items[indexPath.item]
        configureCell(cell, item)
        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        didSelect(item)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}



class ProductViewController: UIViewController {
    
    var items: [ProductModel] = [] {
        didSet{
            setupCollectionViewManagerHelper(with: items)
        }
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private var helper: CollectionViewManagerHelper<ProductModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white

        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupCollectionViewManagerHelper(with products: [ProductModel]) {
        helper = CollectionViewManagerHelper<ProductModel>(
            items: items,
            cellIdentifier: "cell",
            cellSize: CGSize(width: 150, height: 100),
            configureCell: { cell, product in
                if let productCell = cell as? ProductCell {
                    productCell.nameLabel.text = product.name
                }
            },
            didSelect: { product in
                print("Selected: \(product.name)")
            }
        )

        collectionView.dataSource = helper
        collectionView.delegate = helper
        collectionView.reloadData()
    }
    
}


class ProductCell: UICollectionViewCell {
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        nameLabel.frame = contentView.bounds
        nameLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
