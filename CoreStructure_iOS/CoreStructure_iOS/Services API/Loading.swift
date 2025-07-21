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
        loading.color = .white
        loading.style = .large 
        loading.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return loading
    }()
    
    private let lblLoading: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Loading..."
        lbl.textColor = .white
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
    
    func showLoading(alpha: CGFloat = 0.5) {
        DispatchQueue.main.async { [self] in
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                         let window = windowScene.windows.first else { return }

            self.frame = window.bounds
            window.addSubview(self)
            loadingView.frame = window.bounds
            addSubview(loadingView)
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            loadingView.startAnimating()
        }
    }
    
    func hideLoading(seconds: CFTimeInterval = 0.0, completion: (() -> Void)? = nil)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds ){ [self] in
            loadingView.stopAnimating()
            self.removeFromSuperview()
            completion?()
        }
    }
}
