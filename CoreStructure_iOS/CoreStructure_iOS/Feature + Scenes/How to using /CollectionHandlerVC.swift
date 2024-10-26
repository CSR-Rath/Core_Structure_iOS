//
//  CollectionHandlerVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/10/24.
//

import UIKit
import Combine

class CustomCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}


class CollectionHandlerVC: UIViewController {
    
    private let collectionView: UICollectionView
    private var viewModel: CollectionViewHandler<CustomCollectionViewCell, String>!
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // Set your desired item size
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        // Initialize the view model
        viewModel = CollectionViewHandler<CustomCollectionViewCell, String>(
            cellIdentifier: "CustomCollectionViewCell",
            items: ["Item 1", "Item 2", "Item 3"]
        )
        
        // Configure the collection view
        setupCollectionView()
        
        // Configure the cell using a closure
        viewModel.configureCell = { cell, item, _ in
            // Configure your cell here (e.g., set a label's text)
        }
        
        // Handle cell selection
        viewModel.selectedCell = { item in
            print("Selected item: \(item)")
        }
        
        // Observe changes to items
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // Example: Update items dynamically after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel.updateItems(["New Item 1", "New Item 2"])
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the collection view to the view hierarchy
        view.addSubview(collectionView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
