//
//  SliderController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 8/11/24.
//

import UIKit

class SliderVC: BaseUIViewConroller {

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Slider"
        setupViews()
        setupGesture()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        // Add background view
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backgroundView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add slider view
        backgroundView.addSubview(sliderView)
        NSLayoutConstraint.activate([
            sliderView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor),
            sliderView.widthAnchor.constraint(equalToConstant: 50),
            sliderView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            sliderView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor)
        ])
    }

    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sliderView.addGestureRecognizer(panGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: backgroundView)
        let newCenterX = sliderView.center.x + translation.x
        
        // Restrict the slider's movement
        if newCenterX >= sliderView.frame.width / 2 && newCenterX <= backgroundView.frame.width - sliderView.frame.width / 2 {
            sliderView.center.x = newCenterX
            gesture.setTranslation(.zero, in: backgroundView)
        }

        if gesture.state == .ended {
            if sliderView.center.x > backgroundView.frame.width - sliderView.frame.width {
                slideToSuccess()
            } else {
                resetSlider()
            }
        }
    }

    private func slideToSuccess() {
        UIView.animate(withDuration: 0.2) {
            self.sliderView.center.x = self.backgroundView.frame.width - self.sliderView.frame.width / 2
        }
        // Perform action here, e.g., show a success message
        
        openYouTubeVideo(videoID: "oFKyx2CAgyI&list=RDLAkKvMtlRC4&index=12")
        
    }

    private func resetSlider() {
        UIView.animate(withDuration: 0.2) {
            self.sliderView.center.x = self.sliderView.frame.width / 2
        }
    }

    func openYouTubeVideo(videoID: String) {
//        URL(string: "youtube://watch?v=\(videoID)")
        
        if let url =  URL(string: "https://www.youtube.com/@sophearathchhan") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback to the YouTube website if the app is not installed
                if let webUrl = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
                    UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
}
