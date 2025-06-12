//
//  ContentSizedTableView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import Foundation
import UIKit

class ContentSizedTableView: UITableView {// working with vertical
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
