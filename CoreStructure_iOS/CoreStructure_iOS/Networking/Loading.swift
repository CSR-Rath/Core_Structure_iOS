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
        loading.color = .white //.mainBlueColor
        loading.style = .large //.medium
        loading.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return loading
    }()
    
    private let lblLoading: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Loading..."
        lbl.textColor = .white //.mainBlueColor
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lblLoading)
        NSLayoutConstraint.activate([
            lblLoading.centerYAnchor.constraint(equalTo: centerYAnchor,constant: 50),
            lblLoading.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoading(alpha: CGFloat = 0.5 ) {
        DispatchQueue.main.async { [self] in
            
            guard let window = sceneDelegate else {
                print("Window nil")
                return
            }
            self.frame = window.bounds
            window.addSubview(self)
            loadingView.frame = window.bounds
            addSubview(loadingView)
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            loadingView.startAnimating()
        }
    }
    
    func hideLoading(delay: CFTimeInterval = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay ){ [self] in
            loadingView.stopAnimating()
            self.removeFromSuperview()
        }
    }
}
