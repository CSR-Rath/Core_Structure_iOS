//
//  MoreView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/11/24.
//

import UIKit

class MoreView: UIView{
    
    var actionMore: (()->())?
    
    private var nsConstraint = NSLayoutConstraint()
    
    var heightView: CGFloat = 40{
        didSet{
//            nsConstraint.isActive = false
//            nsConstraint.constant = heightView
//            nsConstraint.isActive = true
        }
    }
    
    
    lazy var lblName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var actionView: BaseUIButton = {
        let view = BaseUIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    lazy var lblMore: UILabel = {
        let label = UILabel()
        label.text = "More"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    lazy var imageNext: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var stackMore: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblMore,imageNext])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        nsConstraint =  self.heightAnchor.constraint(equalToConstant: heightView)
        nsConstraint.isActive = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleActionViewTap() {
        // Add your action here
        print("Action view tapped!")
      
        
        UIView.animate(withDuration: 0.05, animations: {
            self.actionView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            self.actionMore?()
            // Scale back to original size
            UIView.animate(withDuration: 0.05) {
                self.actionView.transform = CGAffineTransform.identity
            }
        }
    }
    
    private func setupUI(){
        addSubview(lblName)
        addSubview(actionView)
        actionView.addSubview(stackMore)
        NSLayoutConstraint.activate([
            
            lblName.centerYAnchor.constraint(equalTo: centerYAnchor),
            lblName.leftAnchor.constraint(equalTo: leftAnchor,constant: 15),
            
            actionView.rightAnchor.constraint(equalTo: rightAnchor),
            actionView.topAnchor.constraint(equalTo: topAnchor),
            actionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackMore.rightAnchor.constraint(equalTo: actionView.rightAnchor,constant: -20),
            stackMore.leftAnchor.constraint(equalTo: actionView.leftAnchor,constant: 20),
            stackMore.topAnchor.constraint(equalTo: actionView.topAnchor),
            stackMore.bottomAnchor.constraint(equalTo: actionView.bottomAnchor),
            
            imageNext.heightAnchor.constraint(equalToConstant: 15),
            imageNext.widthAnchor.constraint(equalToConstant: 15),
        ])
    }
    
}
