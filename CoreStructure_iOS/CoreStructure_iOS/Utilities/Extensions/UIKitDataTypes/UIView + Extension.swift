//
//  UIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit

//MARK: for animate show heide
extension UIView{
    
    func animateShow(duration: TimeInterval = 0.5) {
        self.isHidden = false // Make the view visible
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1 // Fade in
        })
    }
    
    func animateHide(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0 // Fade out
        }) { completed in
            self.isHidden = true // Hide the view after the animation
        }
    }
}

extension UIView{
    
    func isHasSafeAreaInsets() -> Bool {
        // Check if the top inset is greater than zero
        return self.safeAreaInsets.top > 0
    }
    
    //MARK: calculate text label width
    func calculateLabelWidth(text: String, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.frame.width
    }
    
}

//MARK: Handle addGestureRecognizer have param UIView
extension UIView{
    
    func addGestureRecognizer(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true // Ensure user interaction is enabled
    }
    
    
    func tapGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc func viewTapped() {
        print("View was tapped! ==> Helper")
    }
    
    
}

//MARK: Handle cornerRadius
extension UIView{
    enum RoundCornersAt{
        case topRight
        case topLeft
        case bottomRight
        case bottomLeft
    }
    
    //multiple corners using CACornerMask
    func roundCorners(corners:[RoundCornersAt], radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [
            corners.contains(.topRight) ? .layerMaxXMinYCorner:.init(),
            corners.contains(.topLeft) ? .layerMinXMinYCorner:.init(),
            corners.contains(.bottomRight) ? .layerMaxXMaxYCorner:.init(),
            corners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init(),
        ]
    }
}


//MARK: Handle UITapGestureRecognizer and UIPanGestureRecognizer
extension UIView {
    
    static var didTapGesture:(()->())?
    static var dropHeight: CGFloat = 200 // Dismiss view contoller
    
    // Adds a tap gesture recognizer to dismiss the view
    func addTapGesture(target: Any,action: Selector ) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
    
    // Adds a pan gesture recognizer to a specified control view
    func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    

    
    
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        switch gesture.state {
        case .changed:
            // Move the view with the gesture
            if translation.y > 0 {
                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
            
        case .ended:
            print("translation.y ===> \(translation.y)")
            
            // Dismiss the view if the swipe is downward
            
            if translation.y > UIView.dropHeight {
                
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity //Reset position
                }
            }
            
            
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity //Reset position
            }
            
            //            if translation.y > UIView.dropHeight {
            //
            //            } else {
            //                UIView.animate(withDuration: 0.1) {
            //                    self.transform = .identity //Reset position
            //                }
            //            }
            
        default:
            
            break
        }
    }
    
    @objc private func cancelDismiss() {
        // Dismissal logic
        
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
        
        
    }
}



//MARK: Keyborad on button
extension UIView{
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    static var actionKeyboardWillShow: ((_ keyboardHeight: CGFloat)->())?
    static var actionKeyboardWillHide: (()->())?
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let  keyboardHeight = keyboardFrame.cgRectValue.height + 20
            
            print("keyboardHeight ==> ",keyboardHeight)
            
            UIView.actionKeyboardWillShow?(keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.actionKeyboardWillHide?()
    }
}


//MARK: Create
extension UIView {
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create a flexible space to push the buttons to the right
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Create a "Done" button
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain, target: self,
                                         action: #selector(doneButtonTapped))
        
        // Create a "Done" button
        //        let cancelButton = UIBarButtonItem(title: "Cancel",
        //                                         style: .plain, target: self,
        //                                         action: #selector(cancelButtonTapped))
        
        // Add buttons to the toolbar
        toolbar.items = [flexibleSpace, doneButton]
        return toolbar
    }
    
    @objc func doneButtonTapped() {
        // Dismiss keyboard
        self.endEditing(true)
    }
    
}



// MARK: - UITapGestureRecognizer and UIPanGestureRecognizer

class HandleTapPanGesture {

    static let shared = HandleTapPanGesture()
    
    // Callback properties
     var onTap: (() -> Void)?
     var onPan: ((CGFloat) -> Void)?

    
    private init() {} // Prevent external initialization
    
    
    func tapGestureHelper(to view: UIView){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTappedHelper))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc func viewTappedHelper() {
        print("View was tapped! ==> Helper")
    }

    func addTapGesture(to view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true // Ensure user interaction is enabled
    }

    func addPanGesture(to view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        view.isUserInteractionEnabled = true // Ensure user interaction is enabled
    }

    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) {
 
        onTap?()
        
    }

    
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let view = gesture.view
        let translation = gesture.translation(in: gesture.view?.superview)
        
        switch gesture.state {
        case .changed: break
            // Move the view with the gesture
            if translation.y > 0 {
                view?.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
//            else{
//                translation.y = 0
//            }
            
        case .ended:
            print("translation.y ===> \(translation.y)")
            
            // Dismiss the view if the swipe is downward
            
            if translation.y > UIView.dropHeight {
                onTap?()
            } else {
                UIView.animate(withDuration: 0.1) {
                    view?.transform = .identity //Reset position
                }
            }
            
        
            
        default:
            
            break
        }
    }

    

}
    
    
// MARK: - Mark makeSecure when screenShot or screenRecord
extension UIView {

    func makeSecure() {
           let field = UITextField()
           let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.self.width, height: field.frame.self.height))
           field.isSecureTextEntry = true
           self.addSubview(field)
           field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
           field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
           self.layer.superlayer?.addSublayer(field.layer)
           field.layer.sublayers?.last?.addSublayer(self.layer)
           field.leftView = view
           field.leftViewMode = .always
       }
}
