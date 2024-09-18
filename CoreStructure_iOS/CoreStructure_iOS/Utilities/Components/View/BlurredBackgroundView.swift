//
//  BlurredBackgroundView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import UIKit

class BlurredBackgroundView: UIView {
    private let blurEffect: UIBlurEffect
    private let blurEffectView: UIVisualEffectView

    init(blurStyle: UIBlurEffect.Style = .regular) {
        blurEffect = UIBlurEffect(style: blurStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
