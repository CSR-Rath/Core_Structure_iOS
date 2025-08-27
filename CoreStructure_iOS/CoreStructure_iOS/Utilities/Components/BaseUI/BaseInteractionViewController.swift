//
//  BaseInteractionViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/12/24.
//

import UIKit

class BaseInteractionViewController: UIViewController {
    
    private var timer: Timer?
    private var duration: Int = 0
    private let maximumDuration: Int = 120 // seconds
    private let interval: TimeInterval = 1.0 // seconds
    
    lazy var bgImg: UIImageView = {
        let img = UIImageView()
//        img.image = .wellpaperAngkorWat
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        startTimer()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        leftBarButtonItem()
        
        view.backgroundColor = .mainBGColor
        
        
        view.addSubviews(of: bgImg)
        bgImg.frame = view.bounds
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        stopTimer()
    }

    deinit {
//        stopTimer()
    }

    private func startTimer() {
       
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil,
                                     repeats: true)
        print("Duration is \(duration)")
    }

    private func stopTimer() {
        duration = 0
        timer?.invalidate()
        timer = nil
        print("Timer reached maximum duration and was stopped.")
    }

    @objc private func timerFired() {
        duration += 1

        if duration >= maximumDuration {
            stopTimer()
        }
    }
}


