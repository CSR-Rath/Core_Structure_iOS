//
//  UIScrollView + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/10/24.
//

import Foundation
import UIKit

extension UIScrollView{ // including tableView collectionView
    
    func addRefreshControl(target: Any, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .mainBlueColor
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refreshControl // Assign the refresh control
    }
    
    func animateScrollCell(index: Int){
        // Animate the cell
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: Double(index) * 0.1, options: .curveEaseOut) {
            self.alpha = 1
        }
    }

}




