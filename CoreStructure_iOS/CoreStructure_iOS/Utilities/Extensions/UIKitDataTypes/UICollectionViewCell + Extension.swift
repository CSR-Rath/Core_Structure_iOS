//
//  UICollectionViewCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import Foundation
import UIKit

extension UICollectionViewCell{
    func animateScrollCell(index: Int){
        // Animate the cell
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: Double(index) * 0.1, options: .curveEaseOut) {
            self.alpha = 1
        }
    }
}
