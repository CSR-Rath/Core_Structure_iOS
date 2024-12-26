//
//  InteractionBaseViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/12/24.
//

import UIKit

fileprivate var timer: Timer?
fileprivate var duration: Int?

class InteractionBaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var increase: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture()
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        duration = 0
    }
    
    private func tapGesture(){
        // Tap gesture recognizer for the view
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap(_:)))
        tapRecognizer.delegate = self
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func viewDidTap(_ recognizer: UITapGestureRecognizer) { // handle tapped reset
        guard let view = recognizer.view else { return }
        
        let location = recognizer.location(in: view)
        let subview = view.hitTest(location, with: nil)
        
        // Check if the tapped view is a button or not
        if let button = subview as? UIButton {
            print("Type UIButton")
        }else{
            print("subview ==> \(subview!)")
        }
        
        startTimer() // stop reload agian or reset timer
    }
    
    private func startTimer() {
        duration = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(increase), target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc private func timerFired() {
        duration! += increase
        print("Timer ==> \(duration!)")
        
        if duration == 50{
            AlertMessage.shared.alertError()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        print("Timer stopped.")
    }
}



//MARK: - How to use InteractionBaseViewController?

/*
 
 + We need inheritance it. Example

 // Subclassing InteractionBaseViewController
 class NameClass: InteractionBaseViewController {

     override func viewDidLoad() {
         super.viewDidLoad()
         Do something
     }
 
 }
 
 */
