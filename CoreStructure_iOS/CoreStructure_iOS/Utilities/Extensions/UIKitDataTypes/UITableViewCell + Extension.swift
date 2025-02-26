//
//  UITableViewCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import Foundation
import UIKit

extension UITableViewCell {
    func animateScrollCell(index: Int) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 30) // Move down initially
        
        UIView.animate(
            withDuration: 0.25, // Duration of the animation
            delay: 0.008 * Double(index), // Small delay for staggered effect
            usingSpringWithDamping: 0.85, // Smooth bouncing effect
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: {
                self.alpha = 1
                self.transform = .identity // Reset position
            }
        )
        
        // MARK: - How to use it.
        
        //var previousOffsetY: CGFloat = 0
        //var isScrollingDown = false
        //
        //func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //    let currentOffsetY = scrollView.contentOffset.y
        //    isScrollingDown = currentOffsetY > previousOffsetY
        //    previousOffsetY = currentOffsetY
        //}

        //if isScrollingDown {
        //    cell.animateScrollCell(index: indexPath.row)
        //}
        
    }
}

