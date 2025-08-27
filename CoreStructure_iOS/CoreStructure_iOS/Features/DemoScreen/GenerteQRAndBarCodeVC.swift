//
//  GenerteQRAndBarCodeVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 1/4/25.
//

import UIKit

class GenerteQRAndBarCodeVC: BaseUIViewConroller {
    
    lazy var viewQRCode: QRCodeView = {
        let view = QRCodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imgQR.image = "Hello Cambodia".toCodeImage(type: .qrCode)
        return view
    }()
    
    lazy var viewBarCode: QRCodeView = {
        let view = QRCodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imgQR.image = "123456789".toCodeImage(type: .barCode128)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Generale QRCode or Bar Code"
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI(){
        
        let stack = UIStackView(arrangedSubviews: [viewQRCode,viewBarCode ])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
}

class QRCodeView: UIView {
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Scan to Claim"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    
    lazy var imgQR: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    lazy var imgLogoCenterQR: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 18
        img.layer.masksToBounds = true
        img.backgroundColor = .red
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addSubview(imgQR)
        addSubview(imgLogoCenterQR)
        addSubview(lblTitle)
        
        NSLayoutConstraint.activate([
            
            imgQR.topAnchor.constraint(equalTo: topAnchor),
            imgQR.centerXAnchor.constraint(equalTo: centerXAnchor),
            imgQR.widthAnchor.constraint(equalToConstant: 200),
            imgQR.heightAnchor.constraint(equalToConstant: 200),
            
            imgLogoCenterQR.centerXAnchor.constraint(equalTo: imgQR.centerXAnchor),
            imgLogoCenterQR.centerYAnchor.constraint(equalTo: imgQR.centerYAnchor),
            imgLogoCenterQR.heightAnchor.constraint(equalToConstant: 36),
            imgLogoCenterQR.widthAnchor.constraint(equalToConstant: 36),
            
            lblTitle.topAnchor.constraint(equalTo: imgQR.bottomAnchor, constant: 10),
            lblTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}

