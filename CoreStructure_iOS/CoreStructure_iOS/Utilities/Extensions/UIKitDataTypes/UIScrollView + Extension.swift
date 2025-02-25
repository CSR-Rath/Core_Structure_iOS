//
//  UIScrollView + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/10/24.
//

import Foundation
import UIKit

// MARK: - For pull refresh include Scrollview, TableView, CollectionView
extension UIScrollView{
    
    func addRefreshControl(target: Any, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue // Customize the color
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        
        if let tableView = self as? UITableView {
            tableView.refreshControl = refreshControl
        } else if let collectionView = self as? UICollectionView {
            collectionView.refreshControl = refreshControl
        }else{
            self.refreshControl = refreshControl
        }
        
    }
    
    func endRefreshing() {
        if let tableView = self as? UITableView {
            tableView.refreshControl?.endRefreshing()
        } else if let collectionView = self as? UICollectionView {
            collectionView.refreshControl?.endRefreshing()
        } else{
            self.refreshControl?.endRefreshing()
        }
    }
}




// MARK: - Pagination Fetch Data include TableView, CollectionView
extension UIScrollView {
    
    func showLoadingSpinner(with title: String = "Fetching data...") {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.color = .gray // Adapt to dark mode
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [spinner, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        
        let containerView = UIView()
        containerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        containerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 60)
        
        if let tableView = self as? UITableView {
            tableView.tableFooterView = containerView
        } else if let collectionView = self as? UICollectionView {
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 60)
            collectionView.reloadData() // Ensure the footer is displayed
        }
    }
    
    func hideLoadingSpinner() {
        if let tableView = self as? UITableView {
            tableView.tableFooterView = nil
        } else if let collectionView = self as? UICollectionView {
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.footerReferenceSize = .zero
            collectionView.reloadData() // Hide the footer
        }
    }
    
}


// MARK: - Handle Empty list for UITableView & UICollectionView
extension UIScrollView {
    
    func setEmptyListView(title: String? = nil,
                          messageImage: UIImage? = nil
    ) {
        let emptyView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: self.bounds.size.width,
                                             height: self.bounds.size.height))
        
        // ImageView
        let messageImageView = UIImageView()
        messageImageView.image = messageImage ?? .imgEmptyList
        messageImageView.contentMode = .scaleAspectFit
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        let titleLabel = UILabel()
        titleLabel.text = title ?? "Data not found."
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(titleLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50),
            messageImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
        
        // Animate image
        animateImageView(messageImageView)
        
        if let tableView = self as? UITableView {
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none
        } else if let collectionView = self as? UICollectionView {
            collectionView.backgroundView = emptyView
        }
    }
    
    func restore() {
        if let tableView = self as? UITableView {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        } else if let collectionView = self as? UICollectionView {
            collectionView.backgroundView = nil
        }
    }
    
    private func animateImageView(_ imageView: UIImageView) {
        UIView.animate(withDuration: 1.0, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: -(.pi / 10))
            }, completion: { _ in
                UIView.animate(withDuration: 1.0, animations: {
                    imageView.transform = .identity
                })
            })
        })
    }
}


extension UIScrollView{
    
    func isPagination(indexPath: IndexPath, arrayOfData: Int, totalItems: Int) -> Bool {
         guard arrayOfData < totalItems else { return false } // No need to paginate if all items are loaded
         
         if let tableView = self as? UITableView {
             let lastSection = tableView.numberOfSections - 1
             let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
             return indexPath.section == lastSection && indexPath.row == lastRow
         }
         
         if let collectionView = self as? UICollectionView {
             let lastSection = collectionView.numberOfSections - 1
             let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
             return indexPath.section == lastSection && indexPath.row == lastItem
         }
         
         return false
     }
}
