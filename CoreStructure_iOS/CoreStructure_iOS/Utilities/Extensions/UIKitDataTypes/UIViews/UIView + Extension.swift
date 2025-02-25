//
//  UIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit



// MARK: Action change screen view contoller
extension UIView{
    
    func viewContainingController() -> UIViewController? {
        // for use push view controller in the UIView
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }

    
    @objc func dismissViewController(animated: Bool = true){
        viewContainingController()?.navigationController?.dismiss(animated: animated)
    }
    
    @objc func popViewController(animated: Bool = true){
        viewContainingController()?.navigationController?.popViewController(animated: animated)
    }
    
    @objc func popToRootViewController(animated: Bool = true){
        viewContainingController()?.navigationController?.popToRootViewController(animated: animated)
    }
    
    @objc func pushViewController(viewController: UIViewController){
        viewContainingController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func popToViewController(viewController: UIViewController){
        viewContainingController()?.navigationController?.popToViewController(viewController, animated: true)
    }
    
    func shareScreenshotView(title: String = "Default Title") {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        
        // Include the title and image as items to share
        let items: [Any] = [title, image] // Add title and image to the share sheet
        
        guard let viewController = viewContainingController() else {
            print("Error: No view controller found")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // iPad-specific handling
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self
            popoverController.sourceRect = self.bounds
            popoverController.permittedArrowDirections = [.up, .down]
        }
        
        viewController.present(activityViewController, animated: true)
    }

}




extension UIView{
    
    func isHasSafeAreaInsets() -> Bool {
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


extension UIView{
    
    func addGestureView(target: Any, action: Selector? = #selector(viewTapped) ) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true // Ensure user interaction is enabled
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
//extension UIView {
//    
//    static var didTapGesture:(()->())?
//    static var dropHeight: CGFloat = 200 // Dismiss view contoller
//    
//    // Adds a tap gesture recognizer to dismiss the view
//    func addTapGesture(target: Any,action: Selector ) {
//        let tapGesture = UITapGestureRecognizer(target: target, action: action)
//        self.addGestureRecognizer(tapGesture)
//    }
//    
//    // Adds a pan gesture recognizer to a specified control view
//    func addPanGesture() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
//        self.addGestureRecognizer(panGesture)
//    }
//    
//    
//    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: self.superview)
//        
//        switch gesture.state {
//        case .changed:
//            // Move the view with the gesture
//            if translation.y > 0 {
//                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
//            }
//            
//        case .ended:
//            print("translation.y ===> \(translation.y)")
//            
//            // Dismiss the view if the swipe is downward
//            
//            if translation.y > UIView.dropHeight {
//                
//            } else {
//                UIView.animate(withDuration: 0.1) {
//                    self.transform = .identity //Reset position
//                }
//            }
//            
//            
//            UIView.animate(withDuration: 0.1) {
//                self.transform = .identity //Reset position
//            }
//            
//            
//            
//        default:
//            
//            break
//        }
//    }
//    
//    @objc private func cancelDismiss() {
//        // Dismissal logic
//        
//        UIView.animate(withDuration: 0.1) {
//            self.transform = .identity
//        }
//        
//        
//    }
//}



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
        
        // Add buttons to the toolbar
        toolbar.items = [flexibleSpace, doneButton]
        return toolbar
    }
    
    @objc func doneButtonTapped() {
        // Dismiss keyboard
        self.endEditing(true)
    }
    
}




// MARK: - Mark makeSecure when screenShot or screenRecord
extension UIView {
    
    func addSubviews(of views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
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


//MARK: for animate show hide with scaling
extension UIView {
    
    func isAnimateShow(duration: TimeInterval = 0.5) {
        self.isHidden = false // Make the view visible
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // Start with small scale
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1 // Fade in
            self.transform = CGAffineTransform.identity // Reset scale to original size
        })
    }
    
    func isAnimateHide(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0 // Fade out
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // Scale down while fading out
        }) { completed in
            self.isHidden = true // Hide the view after the animation
            self.transform = CGAffineTransform.identity // Reset the scale after hide
        }
    }
}
