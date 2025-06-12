//
//  OneTimeCodeTextField.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit

extension OneTimeCodeTextField {
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        print("canPerformAction")
        
       return false
    }
    
    public override func caretRect(for position: UITextPosition) -> CGRect {
        
        print("caretRect")
        
       return .zero
    }
    
    public override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {

        print("selectionRects")

        return   []
    }
}
