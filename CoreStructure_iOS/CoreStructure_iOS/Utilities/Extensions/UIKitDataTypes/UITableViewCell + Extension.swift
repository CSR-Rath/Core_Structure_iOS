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
        // Animate the cell
        self.alpha = 0
        UIView.animate(withDuration: 0.0, delay: Double(index), options: .curveEaseIn) {
            self.alpha = 1
        }
    }
}
