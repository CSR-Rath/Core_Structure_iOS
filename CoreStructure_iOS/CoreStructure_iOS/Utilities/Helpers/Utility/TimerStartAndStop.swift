//
//  TimerStartAndStop.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 22/10/24.
//

import Foundation
import UIKit

class TimerStartAndStop {
    
    var timer: Timer?
    var startTime: Date?
    
    // Function to start the timer
    func startTimer(intervalInSeconds: TimeInterval) {
        // Record the start time
        startTime = Date()
        print("Timer started at: \(startTime!)")
        
        // Schedule the timer
        timer = Timer.scheduledTimer(timeInterval: intervalInSeconds, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    // Function to stop the timer
    func stopTimer() {
        timer?.invalidate()
        print("Timer stopped")
    }
    
    // Function called every time the timer fires
    @objc func timerFired() {
        // Calculate elapsed time since the timer started
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            print("Timer fired! Elapsed time: \(elapsedTime) seconds")
        }
    }
}



fileprivate func statusGreetingDay() {
    
    let hour   = (Calendar.current.component(.hour, from: Date()))
    
    switch hour {
    case 0..<11 : 
        print(NSLocalizedString("Morning", comment: "Morning"))
    case 12..<18 : 
        print(NSLocalizedString("Afternoon", comment: "Afternoon"))
    case 19..<23 : 
        print(NSLocalizedString("Evening", comment: "Evening"))
        
    default:
        break
    }
}
