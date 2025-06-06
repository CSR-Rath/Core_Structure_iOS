//
//  ContentView.swift
//  MultiDatePickerApp
//
//  Created by Peter Ent on 11/2/20.
//

import UIKit
import SwiftUI


struct ContentView: View {
    
    @State private var dateRange: ClosedRange<Date>? = nil
    
    var body: some View {
        
        VStack {
            MultiDatePicker(dateRange: self.$dateRange)
            if let range = dateRange {
                
                
                let startTimestamp = dateRange?.lowerBound.timeIntervalSince1970
                let endTimestamp = dateRange?.upperBound.timeIntervalSince1970

                Text("==> \(range)").padding()// ==> \(startTimestamp)-\(endTimestamp)")

            } else {
                Text("Select two dates").padding()
            }
        }
    }
}


class MyUIKitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Create SwiftUI View
        let swiftUIView = ContentView()
        
        // Embed using UIHostingController
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Add as child view controller
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        // Constrain to fill the parent view
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
}

