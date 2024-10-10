//
//  KeyboradVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit

enum PasscodeAction{
    case payment
    case verifyPasscode
    case changePasscode
    case setupPasscode
    case confirmpasscode
    case none
}

class PasscodeVC: UIViewController {
    
    var digit: Int = 6
    private var textHandle: String = ""
    private let items : [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", ""]
    private var digitCircleView: [UIView] = []
    private var arrayButton: [UIButton] = []
    private var stackButton: UIStackView! = nil
    private var stackButton1: UIStackView! = nil
    private var stackButton2: UIStackView! = nil
    private var stackButton3: UIStackView! = nil
    private var stackButton4: UIStackView! = nil
    private var stackCircle: UIStackView! = nil
    
    var isPasscodeAction : PasscodeAction = .none{
        didSet{
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        FingerPrintAndFaceID.shared.fingerPrintFaceID({ (check) in
        //            switch check {
        //            case .success(_):
        //
        //
        ////               let vc = ViewController()
        ////                self.navigationController?.pushViewController(vc, animated: true)
        //
        //            case .failure( _):
        //
        //                print("failure")
        //                break
        //            case .no:
        //                print("no")
        //                break
        //            }
        //        })
        
    }
}

//MARK: Handle CompleteDigit passcode
extension  PasscodeVC {
    
   private func completeDigit(){
        if isPasscodeAction == .changePasscode{
            
        }
    }
}



//MARK: Setup Keyborad Constraint
extension PasscodeVC{
    
    //MARK: Action on button keyborad
    @objc private func buttonTappedKeyborad(_ sender: UIButton) {
        
        let text = items[sender.tag]
        
        //MARK: Handle delete
        if  sender.tag == 11{
           if textHandle.count > 0 {
              textHandle.removeLast()
               let i =  textHandle.count
               digitCircleView[i].backgroundColor = .gray
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
                    completeDigit()
                }
            }
        }
        
//        //MARK: Handle when complete passcode
//        if  textHandle.count == digit{
//            print("complete passcode equal ==> \(digit)")
//            completeDigit()
//        }
    }
    
    // MARK: Setup UIView
    private func setupUIView(){
        setupCircleView()
        setupKeyborad()
        
        view.addSubview(stackCircle)
        view.addSubview(stackButton)
       
        NSLayoutConstraint.activate([
         
            stackCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -80),

            stackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -30),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
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
        
        for i in 0...11 {
            
            let button = UIButton(type: .system)   //UIButton(type: .system)
            button.backgroundColor = .clear
            button.setTitleColor(.orange, for: .normal)
            button.setTitle(items[i], for: .normal)
            button.layer.cornerRadius = 40
            button.tag = i
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.orange.cgColor
            button.addTarget(self, action: #selector(buttonTappedKeyborad), for: .touchUpInside)
            button.tintColor = .orange
            
            if i == 11{
                button.setImage(.icDelete, for: .normal)
            } else if i == 9{
                button.setImage(.icFaceID, for: .normal)
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
        
        let spacing: CGFloat = 25
        
        stackButton1.axis = .horizontal
        stackButton1.distribution = .fillEqually
        stackButton1.alignment = .fill
        stackButton1.spacing = spacing
        
        stackButton2.axis = .horizontal
        stackButton2.distribution = .fillEqually
        stackButton2.alignment = .fill
        stackButton2.spacing = spacing
        
        stackButton3.axis = .horizontal
        stackButton3.distribution = .fillEqually
        stackButton3.alignment = .fill
        stackButton3.spacing = spacing
        
        stackButton4.axis = .horizontal
        stackButton4.distribution = .fillEqually
        stackButton4.alignment = .fill
        stackButton4.spacing = spacing
        
        
        stackButton = UIStackView(arrangedSubviews: [stackButton1,
                                                     stackButton2,
                                                     stackButton3,
                                                     stackButton4])
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.axis = .vertical
        stackButton.distribution = .fillEqually
        stackButton.alignment = .fill
        stackButton.spacing = 15
    }
    
}



