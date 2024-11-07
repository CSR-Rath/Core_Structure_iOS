//
//  LocalizableContoller.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 7/11/24.
//

import UIKit

class LocalizableContoller: UIViewController {
    
    var isKhmerLanguage: Bool = false
    
    lazy var btnSwitchLang: MainButton = {
        let btn = MainButton()
        btn.setTitle("Switch", for: .normal)
        btn.addTapGesture(target: self, action: #selector(didSwitch))
        return btn
    }()
    
    lazy var lblWelcome: UILabel = {
        let lbl = UILabel()
//        lbl.text = "welcome_message".localizeString()
        return lbl
    }()
    
    lazy var lblGoodBye: UILabel = {
        let lbl = UILabel()
//        lbl.text = "goodbye_message".localizeString()
        return lbl
    }()
    
    lazy var lblError: UILabel = {
        let lbl = UILabel()
//        lbl.text = "goodbye_message".localizeString()
        return lbl
    }()
    
    lazy var stackContainer: UIStackView = {
        let stack  = UIStackView(arrangedSubviews: [lblWelcome,lblGoodBye,lblError,btnSwitchLang])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let wellcon: String = "welcome_message".localizeString()
        let bye: String = "goodbye_message".localizeString()
        print("welcome_message", wellcon)
        print("goodbye_message",bye)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        reloadLabel()
    }
    
    private func setupConstraint(){
        view.addSubview(stackContainer)
        NSLayoutConstraint.activate([
            stackContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
    }
    
   @objc private func didSwitch(){
       isKhmerLanguage.toggle()
       setLanguage(langCode: isKhmerLanguage ?  "km" : "en")
       
       print("isKhmerLanguage \(isKhmerLanguage)")
       
       reloadLabel()
    }
    
    
   private func reloadLabel(){
        lblGoodBye.text = "goodbye_message".localizeString()
        lblWelcome.text = "welcome_message".localizeString()
        lblError.text = "error_message".localizeString()
    }
    
    
}

import UIKit

class ViewController: UIViewController {

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sliderView: UIView = {
        let view = UIView()
//        view.image = .icNextWhite
//        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let url = URL(string: "youtube://watch?v=\(videoID)") {
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


import UIKit

//class ViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Example usage
//        openYouTubeVideo(videoID: "dQw4w9WgXcQ") // Replace with your video ID
//    }
//
//    func openYouTubeVideo(videoID: String) {
//        if let url = URL(string: "youtube://watch?v=\(videoID)") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                // Fallback to the YouTube website if the app is not installed
//                if let webUrl = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
//                    UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
//                }
//            }
//        }
//    }
//}
