//
//  AlertMessageVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/9/24.
//

import UIKit

class AlertErrorVC: UIViewController {
    
    private var initialCenter: CGPoint = .zero
    
    let closeButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white.withAlphaComponent(0.95)
        btn.layer.cornerRadius = 20
        btn.setImage(.icClose.withRenderingMode(.alwaysOriginal), for: .normal)
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
        view.backgroundColor = .white.withAlphaComponent(0.9) // .white
        view.layer.cornerRadius = 15
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
        view.backgroundColor = .black.withAlphaComponent(0.5)
        setupView()
        addPanGesture()
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func setupView() {
        
        closeButton.alpha = 0
        contentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: { [self] in
            closeButton.alpha = 1
            contentView.alpha = 1
            
            contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            closeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { [self] _ in
            contentView.transform = .identity
            closeButton.transform = .identity

        }
        
        view.addSubview(contentView)
        contentView.addSubview(imgCenter)
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblDescription)
        
        // Set up contentView constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            imgCenter.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imgCenter.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imgCenter.heightAnchor.constraint(equalToConstant: 120),
            
            lblTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            lblTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 40),
            
            lblDescription.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 25),
            lblDescription.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -25),
        ])
        
        setupCloseButton()
    }
    
    private func setupCloseButton() {
        // Remove the button if it already exists
        closeButton.removeFromSuperview()
        
        // Add it to the contentView (or view, depending on your need)
        view.addSubview(closeButton)
        // Set button constraints
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setupCloseButtonMove() {
        // Remove the button if it already exists
        closeButton.removeFromSuperview()
        
        // Add it to the contentView (or view, depending on your need)
        contentView.addSubview(closeButton)
        
        // Set button constraints
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 60),
            closeButton.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
}


//MARK: Handle action
extension AlertErrorVC{
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        contentView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let contentView = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        
        print("translation   \(translation.x)  , \(translation.y)")
        
        if gesture.state == .began {
            setupCloseButtonMove()
            initialCenter = contentView.center
        } else if gesture.state == .changed {
            // Update the center based on both X and Y translations
            contentView.center = CGPoint(x: initialCenter.x + translation.x,
                                         y: initialCenter.y + translation.y)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            
            // Determine if the bottom sheet should be dismissed or snapped back
            if abs(translation.y) > 150 || abs(translation.x) > 100 { // Threshold for dismissal
                close()
            } else {
                UIView.animate(withDuration: 0.3) {
                    contentView.center = self.initialCenter
                } completion: { _ in
                    self.setupCloseButton()
                }
            }
        }
    }
    
    @objc private func close() {
        setupCloseButtonMove()
        
        UIView.animate(withDuration: 0.1, animations: { [self] in
            contentView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { _ in
            
            self.dismiss(animated: true, completion: { [self] in
                setupCloseButton()
            })
        }
    }
    
}
