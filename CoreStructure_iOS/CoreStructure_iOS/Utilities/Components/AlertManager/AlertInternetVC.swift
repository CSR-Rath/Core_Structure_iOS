//
//  AlertInternetVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/9/24.
//

import UIKit

class AlertInternetVC: UIViewController {
    
    private var initialCenter: CGPoint = .zero
    
    let closeButton : BaseUIButton = {
        let btn = BaseUIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white.withAlphaComponent(0.95)
        btn.layer.cornerRadius = 30
        btn.setImage(UIImage(named: "ic_close_btn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowOffset = CGSize(width: 0, height: -5)
        btn.layer.shadowRadius = 10
        return btn
    }()
    
    let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.fontBold(35)
        return lbl
    }()
    
    let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.fontRegular(30)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.95) // .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: -5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var imgCenter: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.alpha = 0.15
        img.image = UIImage(named: "ic_network_isn't_connect")
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addPanGesture()
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func setupView() {
//        contentView.isSnimateShow(duration: 0.3)
//        closeButton.animateShow(duration: 0.3)
        
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.addSubview(contentView)
        contentView.addSubview(imgCenter)
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblDescription)
        
        // Set up contentView constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 70),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
        ])
    }
    
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let contentView = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        
        print("translation   \(translation.x)  , \(translation.y)")
        
        if gesture.state == .began {
            
            initialCenter = contentView.center
            
        } else if gesture.state == .changed {

            // Allow movement only upwards
            if translation.y < 0 { // Check if the translation is negative
                contentView.center = CGPoint(x: initialCenter.x, // Keep the original x
                                             y: initialCenter.y + translation.y) // Update y based on translation
            }
            
        } else if gesture.state == .ended || gesture.state == .cancelled {
            
            // Determine if the bottom sheet should be dismissed or snapped back
            if abs(translation.y) > 100 || abs(translation.x) > 150 { // Threshold for dismissal
                close()
            } else{
                UIView.animate(withDuration: 0.3) {
                    contentView.center = self.initialCenter
                } completion: { _ in
                    
                }
            }
        }
    }
    
    @objc private func close() {
        dismiss(animated: true) {
            print("Done")
        }
    }
}
