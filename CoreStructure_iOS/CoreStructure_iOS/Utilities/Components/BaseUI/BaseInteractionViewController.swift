//
//  BaseInteractionViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/12/24.
//

import UIKit

class BaseInteractionViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var timer: Timer?
    private var duration: Int = 0
    private let maximumDuration: Int = 100 // seconds
    private let interval: TimeInterval = 1.0 // seconds

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainColor
        setupTapGesture()
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
        duration = 0
    }

    deinit {
        stopTimer()
        print("BaseInteractionController deinitialized and timer stopped.")
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()
        duration = 0
        print("duration is \(duration)")
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.main.add(timer!, forMode: .common) // prevents freeze during scroll/UI interactions
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        print("Timer reached maximum duration and was stopped.")
    }

    @objc private func timerFired() {
        duration += Int(interval)
        print("Timer ==> \(duration)")
        if duration >= maximumDuration {
            stopTimer()
        }
    }

    private func setupTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapRecognizer.delegate = self
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        startTimer()
    }
}


class DisplayBaseInteractionVC: BaseInteractionViewController {
    
    var a: Int = 0
    var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBarButtonItem(iconButton: .back)
        title = "DisplayBaseInteractionViewController"
        view.backgroundColor = .white
        
        let buttonA = BaseUIButton()
        buttonA.setTitle("Action A", for: .normal)
        buttonA.addTarget(self, action: #selector(tappedA), for: .touchUpInside)
        
        
        let buttonB = BaseUIButton()
        buttonB.setTitle("Action B", for: .normal)
        buttonB.addTarget(self, action: #selector(tappedB), for: .touchUpInside)
        
        
        let buttonC = BaseUIButton()
        buttonC.setTitle("Action C", for: .normal)
        buttonC.addTarget(self, action: #selector(tappedC), for: .touchUpInside)
        
        stack = UIStackView(arrangedSubviews: [
            buttonA,
            buttonB,
            buttonC,
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        setupConstraints()
    }
    
    private func setupConstraints(){
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func tappedA(){
        print("Action Button: \(a)")
    }
    
    @objc private func tappedB(){
        print("Action Button: \(a)")
    }
    
    @objc private func tappedC(){
        print("Action Button: \(a)")
    }
}




//private var timer: Timer?
//private var duration: Int = 0
//private var maximumDuration: Int = 100 // secords

//class BaseInteractionController: UIViewController, UIGestureRecognizerDelegate {
//    
//    private var increase: Int = 1
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        startTimer()
//        tapGestureScreen()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        duration = 0
//    }
//    
//    private func tapGestureScreen(){
//        // Tap gesture recognizer for the view
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap(_:)))
//        tapRecognizer.delegate = self
//        tapRecognizer.cancelsTouchesInView = false
//        self.view.addGestureRecognizer(tapRecognizer)
//    }
//    
//    @objc private func viewDidTap(_ recognizer: UITapGestureRecognizer) { // handle tapped reset
//        guard let view = recognizer.view else { return }
//        
//        let location = recognizer.location(in: view)
//        let subview = view.hitTest(location, with: nil)
//        
//        // Check if the tapped view is a button or not
//        if subview is UIButton {
//            print("Type UIButton")
//        }else{
//            print("subview ==> \(subview!)")
//        }
//        
//        startTimer() // stop reload agian or reset timer
//    }
//    
//    private func startTimer() {
//        duration = 0
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(timeInterval: TimeInterval(increase), 
//                                     target: self,
//                                     selector: #selector(timerFired),
//                                     userInfo: nil,
//                                     repeats: true)
//    }
//    
//    @objc private func timerFired() {
//        duration += increase
//        print("Timer ==> \(duration)")
//        
//        if duration == maximumDuration{
//        
//            print("Timer is stopped.")
//
//        }
//    }
//    
//    deinit {
//        timer?.invalidate()
//        timer = nil
//        print("Timer stopped.")
//    }
//}



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


