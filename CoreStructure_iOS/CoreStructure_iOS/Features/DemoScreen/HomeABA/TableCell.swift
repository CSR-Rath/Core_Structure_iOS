//
//  TableCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 31/7/25.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {
    
    // Background container view
    lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBGColor
        view.alpha = 0.9
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Title label inside viewBg
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
            viewBg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mainLeft),
            viewBg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .mainRight),
            viewBg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            viewBg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .mainRight),
            viewBg.heightAnchor.constraint(equalToConstant: 120),
            
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
