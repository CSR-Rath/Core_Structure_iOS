//
//  PanGesturTwoVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 30/10/24.
//

import UIKit

class PanGestureTwoVC: UIViewController, UIGestureRecognizerDelegate {
    
    let height = ConstantsHeight.screen.height*0.9
    
    
    lazy var backGrountView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        view.backgroundColor = .red
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraint()
        addPanGesture()
        backGrountView.addTapGesture(target: self, action: #selector(didTappedDismiss))
        //Enable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    @objc func didTappedDismiss(){

        UIView.animate(withDuration: 0.1) {
            self.containerView.transform = .identity
        }
        
        self.dismiss(animated: true)
        
    }
    
    private func setupConstraint(){
        view.addSubview(backGrountView)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            
            backGrountView.topAnchor.constraint(equalTo: view.topAnchor),
            backGrountView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backGrountView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backGrountView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.heightAnchor.constraint(equalToConstant: height),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: height/2)
        ])
        
    }
    
    
    func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let isDraggingDown = translation.y > 0
        print("translation.y ===> \(translation.y)")
        
        
        switch gesture.state {
        case .changed:
            // Move the view with the gesture
            if translation.y > -height/2  && isDraggingDown == false{
                containerView.transform = CGAffineTransform(translationX: 0,
                                                            y: translation.y)
            }else if isDraggingDown {
                
                containerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
            
            
        case .ended:
            
            print("translation.y end ===> \(translation.y)")
            
            UIView.animate(withDuration: 0.1) { [self] in
                containerView.transform = CGAffineTransform(translationX: 0, y: -height/2)
            }
            
//            if translation.y < 0 { // is down  from big
//                UIView.animate(withDuration: 0.1) { [self] in
//                    containerView.transform = CGAffineTransform(translationX: 0, y: -height/2)
//                }
//            }else 
//            if translation.y > 180 { // is down from small
//                
//                UIView.animate(withDuration: 0.1) { [self] in
//                    containerView.transform = .identity
//                    self.dismiss(animated: true)
//                }
//               
//                
//            }
//            else if translation.y >= -100 {
//                UIView.animate(withDuration: 0.1) { [self] in
//                    containerView.transform = .identity
//                }
//            }
//            else {
//                UIView.animate(withDuration: 0.1) { [self] in
//                    containerView.transform = CGAffineTransform(translationX: 0, y: -height/2)
//                }
//            }
        default:
            break
        }
    }
    
}

