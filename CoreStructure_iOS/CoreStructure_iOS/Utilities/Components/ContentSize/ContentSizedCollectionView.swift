//
//  ContentSizedCollectionView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import Foundation
import UIKit

class ContentSizedCollectionView: UICollectionView { // working with vertical 

    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}

