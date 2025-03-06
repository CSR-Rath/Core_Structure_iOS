//
//  InteractionBaseViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/12/24.
//

import UIKit

private var timer: Timer?
private var duration: Int = 0
private var maximumDuration: Int = 100 // secords

class BaseInteractionController: UIViewController, UIGestureRecognizerDelegate {
    
    private var increase: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        tapGestureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        duration = 0
    }
    
    private func tapGestureScreen(){
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
        if subview is UIButton {
            print("Type UIButton")
        }else{
            print("subview ==> \(subview!)")
        }
        
        startTimer() // stop reload agian or reset timer
    }
    
    private func startTimer() {
        duration = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(increase), 
                                     target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func timerFired() {
        duration += increase
        print("Timer ==> \(duration)")
        
        if duration == maximumDuration{
        
            print("Timer is stopped.")

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
