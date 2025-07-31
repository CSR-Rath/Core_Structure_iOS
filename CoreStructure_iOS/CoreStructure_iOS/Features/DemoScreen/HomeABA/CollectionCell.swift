//
//  CollectionCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 31/7/25.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    // Background container view
    lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBGColor
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Title label inside viewBg
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.fontBold(16)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
           backgroundColor = .clear
           contentView.backgroundColor = .clear
           setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(viewBg)
        viewBg.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // viewBg constraints
            viewBg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            viewBg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            viewBg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            viewBg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            
            // titleLabel constraints inside viewBg
            titleLabel.leadingAnchor.constraint(equalTo: viewBg.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: viewBg.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: viewBg.centerYAnchor),
        ])
    }
    
    // MARK: - Configure cell with title text
    func configure(title: String) {
        titleLabel.text = title
    }
}
