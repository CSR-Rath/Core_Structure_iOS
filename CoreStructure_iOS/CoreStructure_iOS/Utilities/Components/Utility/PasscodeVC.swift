//
//  KeyboradVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import ReplayKit

enum PasscodeAction{
    case payment
    case verifyPasscode
    case changePasscode
    case setupPasscode
    case confirmpasscode
    case none
}


//extension UIView {
//    func screenShotPrevension() {
//        let preventedView = UITextField()
//        let view = UIView()
//        view.frame = UIScreen.main.bounds
//        preventedView.isSecureTextEntry = true
//        self.addSubview(preventedView)
//        preventedView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        preventedView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.layer.superlayer?.addSublayer(preventedView.layer)
//        preventedView.layer.sublayers?.last?.addSublayer(self.layer)
//        preventedView.leftView = view
//        preventedView.leftViewMode = .always
//    }
//}


class PasscodeVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    private var digit: Int = 6
    private var textHandle: String = ""
    private var isFaceID : Bool = false
    private let items : [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", ""]
    private var digitCircleView: [UIView] = []
    private var arrayButton: [UIButton] = []
    private var stackButton: UIStackView! = nil
    private var stackButton1: UIStackView! = nil
    private var stackButton2: UIStackView! = nil
    private var stackButton3: UIStackView! = nil
    private var stackButton4: UIStackView! = nil
    private var stackCircle: UIStackView! = nil
    private var btnForGot = UIButton()
    
    var isPasscodeAction : PasscodeAction = .none
    private var captureWarningView: UIView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self // enable swap
        setupObservers()
        setupCaptureWarningView()
        
        // Add observer for screen capture status change
//        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }

    private func setupCaptureWarningView() {
            captureWarningView = UIView(frame: self.view.bounds)
            captureWarningView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            captureWarningView.isHidden = true
            
            let warningLabel = UILabel()
            warningLabel.text = "Screen recording is active."
            warningLabel.textColor = .white
            warningLabel.textAlignment = .center
            warningLabel.translatesAutoresizingMaskIntoConstraints = false
            
            captureWarningView.addSubview(warningLabel)
            self.view.addSubview(captureWarningView)

            // Constraints for the label
            NSLayoutConstraint.activate([
                warningLabel.centerXAnchor.constraint(equalTo: captureWarningView.centerXAnchor),
                warningLabel.centerYAnchor.constraint(equalTo: captureWarningView.centerYAnchor)
            ])
        }

        private func setupObservers() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(screenCaptureStatusChanged),
                                                   name: UIScreen.capturedDidChangeNotification,
                                                   object: nil)
        }

        @objc private func screenCaptureStatusChanged() {
            if UIScreen.main.isCaptured {
                // Show the warning view when screen capture is detected
                captureWarningView.isHidden = false
                showAlternateView()
            } else {
                // Hide the warning view when screen capture is stopped
                captureWarningView.isHidden = true
                hideAlternateView()
            }
        }

        private func showAlternateView() {
            // Logic to switch to another view
            // For example, you can replace the current view with a placeholder
            // or navigate to a different screen
            let alternateVC = UIViewController()
            alternateVC.view.backgroundColor = .gray // Example color
            alternateVC.modalPresentationStyle = .fullScreen
            self.present(alternateVC, animated: true, completion: nil)
        }

        private func hideAlternateView() {
            // Logic to dismiss the alternate view if it's presented
            if let presentedVC = self.presentedViewController {
                presentedVC.dismiss(animated: true, completion: nil)
            }
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
}

//MARK: Handle CompleteDigit passcode
extension  PasscodeVC {
    
    private func completeDigit(passcod: String){
        
        if passcod == "999999"{
            print("True")
        }else{
            UIDevice.vibrateOnWrongPassword()
        }
        
        
        if isPasscodeAction == .changePasscode{
            
        }
    }
}

// MARK: - Handle biometricAuthentication
extension PasscodeVC{
    
    private func biometricAuthentication(){
        //
        BiometricAuthenticationManager.shared.fingerPrintFaceID { result in
            switch result {
            case .success(let status):
                print("Authentication successful: \(status)") // Navigate or perform action based on success
                
                let vc = UIViewController()
                vc.view.backgroundColor = .green
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .failure(let message):
                
                print("Authentication failed: \(message)")
                
            case .unavailable(let errorCode):
                print("Biometric authentication not available, error code: \(errorCode)")
                // Optionally show an alert
                self.showAlert(message: "Biometric authentication not available. Error code: \(errorCode)")
            }
        }
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Authentication Status", message: message, preferredStyle: .alert)
        
        // Add "OK" action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        // Add "Settings" action to open the app's settings
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: Handle action on button keyborad
extension PasscodeVC{
    
    @objc private func buttonTappedKeyborad(_ sender: UIButton) {
        
        UIDevice.generateButtonFeedback()
        
        let text = items[sender.tag]
        print("text  ==> \(text)")
        
        //MARK: Handle delete
        if  sender.tag == 11{
            if textHandle.count > 0 {
                textHandle.removeLast()
                let i =  textHandle.count
                digitCircleView[i].backgroundColor = .gray
            }
        }
        else if sender.tag == 9{
            
            if !isFaceID{
                biometricAuthentication()
            }
        }
        else{
            
            //MARK: Handle button number
            if  textHandle.count < digit{
                let i =  textHandle.count
                digitCircleView[i].backgroundColor = .orange
                textHandle.append(text)
                
                //MARK: Handle when complete passcode
                if  textHandle.count == digit{
                    print("complete passcode equal ==> \(digit)")
                    completeDigit(passcod: textHandle)
                    
                }else{
                    
                }
            }
        }
    }
}

// MARK: Handle NSLayoutConstraint
extension PasscodeVC{
    
    private func setupUIView(){
        setupCircleView()
        setupKeyborad()
        
        view.addSubview(stackCircle)
        view.addSubview(stackButton)
        view.addSubview(btnForGot)
        
        btnForGot.setTitle("Forgot Passcode", for: .normal)
        btnForGot.setTitleColor(.orange, for: .normal)
        btnForGot.titleLabel?.fontBold(14)
        btnForGot.translatesAutoresizingMaskIntoConstraints = false
        
        btnForGot.addTarget(self, action:  #selector(didTappedForgot), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            stackCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
            
            stackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -50),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            btnForGot.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            btnForGot.rightAnchor.constraint(equalTo: stackButton.rightAnchor),
            
        ])
    }
    
    
    @objc func didTappedForgot(){
        print("didTappedForgot")
    }
    
    
    // MARK: Setup Circle View Passcode
    private func setupCircleView(){
        
        for i in 0...digit-1 {
            print(i)
            let circle = UIView()
            circle.layer.cornerRadius = 10
            circle.backgroundColor = .gray
            circle.layer.borderWidth = 1
            circle.layer.borderColor = UIColor.orange.cgColor
            circle.heightAnchor.constraint(equalToConstant: 20).isActive = true
            circle.widthAnchor.constraint(equalToConstant: 20).isActive = true
            digitCircleView.append(circle)
        }
        
        stackCircle =  UIStackView(arrangedSubviews: digitCircleView)
        stackCircle.translatesAutoresizingMaskIntoConstraints  = false
        stackCircle.axis = .horizontal
        stackCircle.distribution = .fill
        stackCircle.alignment = .fill
        stackCircle.spacing = 15
        
    }
    
    // MARK: Setup Button View Keyborad
    private func setupKeyborad(){
        
        for index in 0...11 {
            
            let button = MainButton(type: .system)   //UIButton(type: .system)
            button.backgroundColor = .clear
            button.setTitleColor(.orange, for: .normal)
            button.setTitle(items[index], for: .normal)
            button.layer.cornerRadius = 40
            button.tag = index
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.orange.cgColor
            button.addTarget(self, action: #selector(buttonTappedKeyborad), for: .touchUpInside)
            button.tintColor = .orange
            
            if index == 9{
                button.setImage(.icFaceID, for: .normal)
            } else if index == 11{
                button.setImage(.icDeletePasscode, for: .normal)
            }
            
            button.heightAnchor.constraint(equalToConstant: 80).isActive = true
            button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            arrayButton.append(button)
        }
        
        stackButton1 = UIStackView(arrangedSubviews: [arrayButton[0],
                                                      arrayButton[1],
                                                      arrayButton[2]])
        
        stackButton2 = UIStackView(arrangedSubviews: [arrayButton[3],
                                                      arrayButton[4],
                                                      arrayButton[5]])
        
        stackButton3 = UIStackView(arrangedSubviews: [arrayButton[6],
                                                      arrayButton[7],
                                                      arrayButton[8]])
        
        stackButton4 = UIStackView(arrangedSubviews: [arrayButton[9],
                                                      arrayButton[10],
                                                      arrayButton[11]])
        
        setupStackButton(stack: [stackButton1, stackButton2, stackButton3, stackButton4])
        
        stackButton = UIStackView(arrangedSubviews: [stackButton1,
                                                     stackButton2,
                                                     stackButton3,
                                                     stackButton4])
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.axis = .vertical
        stackButton.distribution = .fillEqually
        stackButton.alignment = .fill
        stackButton.spacing = 15
        stackButton.makeSecure()
    }
    
    private func setupStackButton(stack: [UIStackView]){
        stack.forEach({ itemStack in
            itemStack.axis = .horizontal
            itemStack.distribution = .fillEqually
            itemStack.alignment = .fill
            itemStack.spacing = 20
        })
    }
}


