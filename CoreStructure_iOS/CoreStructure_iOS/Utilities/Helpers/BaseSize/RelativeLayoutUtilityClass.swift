//
//  RelativeLayoutUtilityClass.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/10/24.
//

import Foundation

class RelativeLayoutUtilityClass {

    var heightFrame: CGFloat?
    var widthFrame: CGFloat?

    init(referenceFrameSize: CGSize){
        heightFrame = referenceFrameSize.height
        widthFrame = referenceFrameSize.width
    }

    func relativeHeight(multiplier: CGFloat) -> CGFloat{

        return multiplier * self.heightFrame!
    }

    func relativeWidth(multiplier: CGFloat) -> CGFloat{
        return multiplier * self.widthFrame!

    }
}
