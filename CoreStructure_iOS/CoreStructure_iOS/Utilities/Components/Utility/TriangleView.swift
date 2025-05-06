//
//  TriangleView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 29/11/24.
//

import UIKit

//ត្រីកោណកែង
class TriangleView: UIView {

    override func draw(_ rect: CGRect) {
        // Define the path for the triangle
        let path = UIBezierPath()
        
        // Set the starting point (bottom left corner)
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Draw to the right corner (bottom right)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Draw to the top corner (top left)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        // Close the path
        path.close()
        
        // Set the fill color
        UIColor.white.setFill() // You can change the color
        path.fill()
    }
    
}
