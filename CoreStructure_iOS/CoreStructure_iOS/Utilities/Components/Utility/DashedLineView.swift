//
//  DashedLineView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 29/11/24.
//

import UIKit

class DashedLineView: UIView {
    
    var lineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()
        let dashPattern: [CGFloat] = [4, 4] // [dash length, gap length]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        path.lineWidth = 1
        path.move(to: CGPoint(x: 0, y: frame.height / 2))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height / 2))
        lineColor.setStroke()
        path.stroke()

    }
}
