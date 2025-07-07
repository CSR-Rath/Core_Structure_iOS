//
//  NetworkMonitorManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/3/25.
//

import UIKit
import Network

class NetworkMonitorManager {
    static let shared = NetworkMonitorManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    private var isConnected: Bool = false
    
    // Create a closure to react to changes
    var onStatusChange: ((Bool) -> Void)?
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let newStatus = path.status == .satisfied
            if self.isConnected != newStatus {
                self.isConnected = newStatus
                
                // Call the closure when status changes
                DispatchQueue.main.async {
                    self.onStatusChange?(newStatus)
                }
            }
        }
        monitor.start(queue: queue)
    }
}


class AlertNetwork: UIViewController{
    
    lazy var constainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .orange
        return view
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.fontBold( 14, color: .black)
        lbl.text = "No Internet Connection"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.fontRegular( 14, color: .black)
        lbl.text = "Please check your internet connection and try again."
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUIView()
        
//        constainer.isHidden = false
//        constainer.alpha = 0
//        UIView.animate(withDuration: 0.3, animations: {
//            self.constainer.alpha = 1
//        })
    }
    
    private func setupUIView(){
        view.addSubview(constainer)
        constainer.addSubview(lblTitle)
        constainer.addSubview(lblDescription)
        
        NSLayoutConstraint.activate([
            
            constainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            constainer.heightAnchor.constraint(equalToConstant: 100),
            constainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            constainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0),
            
            lblTitle.topAnchor.constraint(equalTo: constainer.topAnchor, constant: 15),
            lblTitle.leftAnchor.constraint(equalTo: constainer.leftAnchor,constant: 20),
            lblTitle.rightAnchor.constraint(equalTo: constainer.rightAnchor,constant: -20),
            
            lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 5),
            lblDescription.leftAnchor.constraint(equalTo: constainer.leftAnchor,constant: 20),
            lblDescription.rightAnchor.constraint(equalTo: constainer.rightAnchor,constant: -20),
            lblDescription.bottomAnchor.constraint(equalTo: constainer.bottomAnchor,constant: -20),
            
        ])
    }
    
    func showView(_ view: UIView) {
        view.isHidden = false
        view.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 1
        })
    }

    func hideView(_ view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0
        }) { _ in
            view.isHidden = true
        }
    }

}
