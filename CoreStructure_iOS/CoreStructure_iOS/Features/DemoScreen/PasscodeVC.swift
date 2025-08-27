//
//  KeyboradVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import ReplayKit


enum PasscodeActionEnum{
    case payment
    case verifyPasscode
    case changePasscode
    case setupPasscode
    case confirmpasscode
    case none
}

class PasscodeVC: BaseUIViewConroller {
    
    private var digit: Int = 6
    private var textHandle: String = ""
    private var isFaceID : Bool = false
    private let items : [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", ""]
    private var digitCircleView: [UIView] = []
    private var stackButton: UIStackView! = nil
    private var stackCircle: UIStackView! = nil
    private var btnForGot = UIButton()
    private var arrayButton: [UIButton] = []
    
    var digitColor: UIColor = .clear

    var isPasscodeAction : PasscodeActionEnum = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Passcode"
        setupUIView()
    }
    
}

//MARK: Handle CompleteDigit passcode
extension  PasscodeVC {
    
    private func completeDigit(passcod: String){
        
        if passcod == "999999"{
            susseccfullyPasscode()
        }
        else{
            
            UIDevice.vibrateOnWrongPassword()
            UIDevice.shakeStackView(to: stackCircle)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                self.textHandle.removeAll()
                self.digitCircleView.forEach { item in
                    item.backgroundColor = self.digitColor
                }
            }

        }
    }
    
    
    private func susseccfullyPasscode(){
        self.pushVC(to: SuccessfullyVC())
        
    }

}

// MARK: - Handle biometricAuthentication
extension PasscodeVC{
    
    private func biometricAuthentication(){
    
        BiometricAuthenticationManager.shared.fingerPrintFaceID { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let status):
                print("Authentication successful: \(status)") // Navigate or perform action based on success
                self.susseccfullyPasscode()
                
            case .failure(let message):
            
                print("Authentication failed: \(message)") // Navigate or perform action based on success
                
            case .unavailable(let errorCode):
                
                print("Biometric authentication not available. Error code: \(errorCode)")
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
        
        let text = items[sender.tag]
        
        //MARK: Handle delete
        if  sender.tag == 11{
            if textHandle.count > 0 {
                textHandle.removeLast()
                let i =  textHandle.count
                digitCircleView[i].backgroundColor = digitColor
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
        
        UIDevice.generateButtonFeedback()
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
            
            stackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                constant: -50),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            btnForGot.bottomAnchor.constraint(equalTo: stackButton.topAnchor, constant: -20),
            btnForGot.rightAnchor.constraint(equalTo: stackButton.rightAnchor),
            
        ])
    }
    
    
    @objc func didTappedForgot(){
        print("didTappedForgot")
    }
    
    
    // MARK: Setup Circle View Passcode
    private func setupCircleView(){
        
        for i in 0...digit-1 {
            let circle = UIView()
            circle.layer.cornerRadius = 10
            circle.backgroundColor = digitColor
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
        
         var stackButton1: UIStackView! = nil
         var stackButton2: UIStackView! = nil
         var stackButton3: UIStackView! = nil
         var stackButton4: UIStackView! = nil
        
        
        for index in 0...11 {
            
            let button = BaseUIButton(type: .system)  
            button.backgroundColor = digitColor
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
            
            button.buttonHeight = 80
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
        
        let stackAll: [UIStackView] = [stackButton1, stackButton2, stackButton3, stackButton4]
        
        setupStackButton(stack: stackAll)

        stackButton = UIStackView(arrangedSubviews: stackAll)
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.axis = .vertical
        stackButton.distribution = .fillEqually
        stackButton.alignment = .fill
        stackButton.spacing = 15

    }
    
    // MARK: Getup stack horizontal button have 4 stack (1-3, 4-6, 7-9, icone-0-delete)
    private func setupStackButton(stack: [UIStackView]){
        stack.forEach({ itemStack in
            itemStack.axis = .horizontal
            itemStack.distribution = .fillEqually
            itemStack.alignment = .fill
            itemStack.spacing = 20
        })
    }
}
