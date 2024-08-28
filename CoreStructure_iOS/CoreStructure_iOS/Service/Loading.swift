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
        loading.color = .blue
        loading.style = .large
        loading.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()
    
    
     func showLoading() {
        
        DispatchQueue.main.async {
            let window = SceneDelegate().window //UIApplication.shared.windows.first
            
            self.frame = CGRect(x: 0, y: 0, width: (window?.frame.width)!,
                           height: (window?.frame.height)!)
            window?.addSubview(self)
        }
        
        DispatchQueue.main.async { [self] in

            addSubview(loadingView)
            
            NSLayoutConstraint.activate([
                loadingView.widthAnchor.constraint(equalTo: window!.widthAnchor),
                loadingView.heightAnchor.constraint(equalTo: window!.heightAnchor),
                loadingView.centerYAnchor.constraint(equalTo: window!.centerYAnchor),
                loadingView.centerXAnchor.constraint(equalTo: window!.centerXAnchor),
            ])
            
            loadingView.startAnimating()
        }
    }
    
     func hideLoading(_ deadline: CFTimeInterval = 0.0) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + deadline ){ [self] in
            removeFromSuperview()
            loadingView.removeFromSuperview()
            loadingView.stopAnimating()
        }
    }
}
