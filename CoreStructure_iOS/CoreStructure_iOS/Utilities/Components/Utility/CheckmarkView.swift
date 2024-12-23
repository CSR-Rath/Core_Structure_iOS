//
//  CheckmarkView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 14/8/24.
//

import Foundation
import UIKit

class CheckmarkView: UIView , CAAnimationDelegate{
  
    var color: UIColor = .red
    var didFinishAnimate : (()-> Void)?
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.size.width * 0.25, y: rect.size.height * 0.5))
        path.addLine(to: CGPoint(x: rect.size.width * 0.4, y: rect.size.height * 0.65))
        path.addLine(to: CGPoint(x: rect.size.width * 0.75, y: rect.size.height * 0.35))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.fillColor = nil
        shapeLayer.cornerRadius = 10

        layer.addSublayer(shapeLayer)
        
        animateStroke(layer: shapeLayer, duration: 0.3, repeatCount: 1) // Repeat the animation 1 times
        
    }

    
    private func animateStroke(layer: CAShapeLayer, duration: CFTimeInterval, repeatCount: Float = 1) {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.duration = duration

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeAnimation]
        animationGroup.delegate = self
        animationGroup.duration = duration
        animationGroup.repeatCount = repeatCount
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards
        
        layer.add(animationGroup, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true{
            self.didFinishAnimate?()
        }
    }
}
