//
//  BaseUIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 2/1/25.
//

import UIKit
import SwiftUI

class BaseUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
