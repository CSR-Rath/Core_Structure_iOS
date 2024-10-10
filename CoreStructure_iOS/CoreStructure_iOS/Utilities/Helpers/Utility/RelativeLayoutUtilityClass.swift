//
//  RelativeLayoutUtilityClass.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/10/24.
//

import Foundation

//MARK: For percentage of size (Width, Height)
class RelativeLayoutUtilityClass {

    var heightFrame: CGFloat?
    var widthFrame: CGFloat?

    init(referenceFrameSize: CGSize){
        heightFrame = referenceFrameSize.height
        widthFrame = referenceFrameSize.width
    }

    //Max > 1 = 100%
    func relativeHeight(multiplier: CGFloat) -> CGFloat{

        return multiplier * self.heightFrame!
    }

    //Max > 1 = 100%
    func relativeWidth(multiplier: CGFloat) -> CGFloat{
        return multiplier * self.widthFrame!

    }
}
