//
//  UIScrollView + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/10/24.
//

import UIKit

enum IconEmptyList {
    case back
    case close
    
    var image: UIImage? {
        switch self {
        case .back:
            return UIImage(named: "back_icon")
        case .close:
            return UIImage(named: "close_icon")
        }
    }
}



extension UIScrollView {
    
    func addRefreshControl(tintColor: UIColor = .blue,
                           target: Any,
                           action: Selector) {
        
        // Otherwise, create a new one
        let refresh = UIRefreshControl()
        refresh.tintColor = tintColor
        refresh.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refresh
    }
    
    func stopRefreshing() {
        self.refreshControl?.endRefreshing()
    }
}

// MARK: - Handle Empty list for UITableView & UICollectionView
extension UIScrollView {
    
    func isShowEmptyState(messsage: String? = nil,
                          icon: IconEmptyList = .back
    ) {
        let emptyView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: self.bounds.size.width,
                                             height: self.bounds.size.height))
        
        // ImageView
        let messageImageView = UIImageView()
        messageImageView.image = icon.image
        messageImageView.contentMode = .scaleAspectFit
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        let titleLabel = UILabel()
        titleLabel.text = messsage ?? "Data not found."
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
    
    func isRestoreEmptyState() {
        if let tableView = self as? UITableView {
            tableView.backgroundView = nil
            tableView.separatorStyle = .none
        } else if let collectionView = self as? UICollectionView {
            collectionView.backgroundView = nil
        }
    }
    
    private func animateImageView(_ imageView: UIView) {
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
    
    func isPagination(indexPath: IndexPath,
                      arrayCount: Int,
                      totalItems: Int) -> Bool {
        guard arrayCount < totalItems else { return false } // No need to paginate if all items are loaded
        
        if let tableView = self as? UITableView {
            let lastSection = tableView.numberOfSections - 1
            let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
            
            if (indexPath.section == lastSection && indexPath.row == lastRow){
                isShowLoadingSpinner()
                return true
            }
        }
        
        if let collectionView = self as? UICollectionView {
            let lastSection = collectionView.numberOfSections - 1
            let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
            
            if  (indexPath.section == lastSection && indexPath.row == lastItem) {
                isShowLoadingSpinner()
                return true
            }
        }
        return false
    }
    
    private func isShowLoadingSpinner(with message: String = "Fetching") {
        // Create spinner and start animating
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.color = .red // Adapt to dark mode
        
        // Create title label for dynamic dots
        let titleLabel = UILabel()
        titleLabel.text = message
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // Stack view for spinner and label
        let stackView = UIStackView(arrangedSubviews: [spinner, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        // Container view to hold the stack view
        let containerView = UIView()
        containerView.addSubview(stackView)
        
        // Layout constraints for stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        // Set container view size
        containerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 60)
        
        // Update footer view based on the type of view (tableView or collectionView)
        if let tableView = self as? UITableView {
            tableView.tableFooterView = containerView
        } else if let collectionView = self as? UICollectionView {
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 60)
            collectionView.reloadData() // Ensure the footer is displayed
        }
        
        // Animate the loading dash with a sequence of dots
        var dotCount = 1
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            let dotString = String(repeating: ".", count: dotCount)
            titleLabel.text = message + "\(dotString)"
            
            // Update dot count
            dotCount = (dotCount % 3) + 1
            
            // Stop animation when the data is ready
            // Example: Stop after 10 seconds (replace this condition as needed)
            if dotCount > 10 {
                timer.invalidate()
            }
        }
    }
    
    func isHideLoadingSpinner() {
        if let tableView = self as? UITableView {
            tableView.tableFooterView = nil
        } else if let collectionView = self as? UICollectionView {
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.footerReferenceSize = .zero
            collectionView.reloadData() // Hide the footer
        }
    }
    
}
