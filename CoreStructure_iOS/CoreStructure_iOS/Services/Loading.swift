//
//  Loading.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit


class Loading : UIView {
    
    static let shared = Loading()
    
    private let loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .mainBlueColor
        loading.style = .large//.medium
        loading.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return loading
    }()
    
    lazy var lblLoading: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Loading..."
        lbl.textColor = .mainBlueColor
        return lbl
    }()
    
    
    func showLoading() {

        DispatchQueue.main.async { [self] in
            

            guard let window = SceneDelegate.shared.sceneDelegate?.window else{
                return
            }
    
            self.frame = window.bounds
            window.addSubview(self)
            
            loadingView.frame = window.bounds
            addSubview(loadingView)
            
            
            addSubview(lblLoading)
            NSLayoutConstraint.activate([
                lblLoading.centerYAnchor.constraint(equalTo: centerYAnchor,constant: 50),
                lblLoading.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
            
            loadingView.startAnimating()
        }
    }
    
    func hideLoading(delay: CFTimeInterval = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay ){ [self] in
            self.removeFromSuperview()
            lblLoading.removeFromSuperview()
            loadingView.removeFromSuperview()
            loadingView.stopAnimating()
        }
    }
}
