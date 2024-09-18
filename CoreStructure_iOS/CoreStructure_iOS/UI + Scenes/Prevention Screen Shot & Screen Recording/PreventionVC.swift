//
//  PreventionVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit

class PreventionVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        // Add observer for screen capture status change
        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
        
    }
    
    
    
    
    
    
    // Method called when screen capture status changes
    @objc func preventScreenRecording(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen else {
            return
        }
        
        if screen.isCaptured {
            // Screen recording has started, take appropriate action
            // For example, pause the app, hide sensitive content, or display a watermark
        } else {
            // Screen recording has stopped, resume normal app behavior
            // Undo any actions taken when recording started
        }
    }
    
}



class SecureOverlayView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YourViewController: UIViewController {
    let secureOverlay = SecureOverlayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        // Setup the overlay view
        secureOverlay.frame = self.view.bounds
        self.view.addSubview(secureOverlay)
        
        // Observe app state changes
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sceneWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Add observer for screen capture status change
        NotificationCenter.default.addObserver(self, selector: #selector(screenCaptureStatusDidChange), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
    
    
    
    // Selector method to handle screen capture status change
    @objc func screenCaptureStatusDidChange() {
        if UIScreen.main.isCaptured {
            // Screen recording has started
            showOverlay()
        } else {
            // Screen recording has stopped
            hideOverlay()
        }
    }
    
    func showOverlay() {
        // Implement your overlay logic here
        print("Screen recording started. Show overlay.")
    }
    
    func hideOverlay() {
        // Implement your hide overlay logic here
        print("Screen recording stopped. Hide overlay.")
    }
    
    
    
    @objc func didBecomeActiveNotification() {
        secureOverlay.isHidden = true
    }
    
    @objc func sceneWillResignActive() {
        secureOverlay.isHidden = false
    }
    
    @objc func appDidEnterBackground() {
        secureOverlay.isHidden = false
    }
    
    @objc func appWillEnterForeground() {
        //        secureOverlay.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//
//class PreventionScreen: UIViewController{
//    
//    let viewScreen = UIView()
//    
//    lazy var viewContainer: BlurredBackgroundView = {
//        let view = BlurredBackgroundView()
//        view.backgroundColor = .orange //.withAlphaComponent(0.05)
//        return view
//    }()
//    
//    lazy var alertView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 10
//        return view
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        viewContainer.frame = view.bounds
//        view.addSubview(viewContainer)
//        viewContainer.addSubview(alertView)
//        
//        
//        alertView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            alertView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor,constant: 100),
//            alertView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor,constant: -100),
//            alertView.heightAnchor.constraint(equalToConstant: 200),
//            alertView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor)
//        ])
//        
//        
//        viewScreen.backgroundColor = .green
//        
//        guard let secureView = SecureField().secureContainer else {return}
//        secureView.addSubview(viewScreen)
//
//        viewScreen.pinEdges()
//        self.view.addSubview(secureView)
//        secureView.pinEdges()
//    }
//}
//
//
//
//
//class SecureField : UITextField {
//    
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        self.isSecureTextEntry = true
//        self.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    weak var secureContainer: UIView? {
//        let secureView = self.subviews.filter({ subview in
//            type(of: subview).description().contains("CanvasView")
//        }).first
//        secureView?.translatesAutoresizingMaskIntoConstraints = false
//        secureView?.isUserInteractionEnabled = true //To enable child view's userInteraction in iOS 13
//        return secureView
//    }
//    
//    override var canBecomeFirstResponder: Bool {false}
//    override func becomeFirstResponder() -> Bool {false}
//}
//
//extension UIView {
//    
//    func pin(_ type: NSLayoutConstraint.Attribute) {
//        translatesAutoresizingMaskIntoConstraints = false
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: type,
//                                            relatedBy: .equal,
//                                            toItem: superview, attribute: type,
//                                            multiplier: 1, constant: 0)
//        
//        constraint.priority = UILayoutPriority.init(999)
//        constraint.isActive = true
//    }
//    
//    func pinEdges() {
//        pin(.top)
//        pin(.bottom)
//        pin(.leading)
//        pin(.trailing)
//    }
//}



import UIKit

class PreventionScreen: UIViewController {
    
    let viewScreen = UIView()
    
    lazy var viewContainer: BlurredBackgroundView = {
        let view = BlurredBackgroundView()
        view.backgroundColor = .orange
        return view
    }()
    
    lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var viewRecording: BlurredBackgroundView = {
        let view = BlurredBackgroundView()
        view.backgroundColor = .blue
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

//        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
        
        
    }
    
    private func setupUI() {
        viewContainer.frame = view.bounds
        view.addSubview(viewContainer)
        viewContainer.addSubview(alertView)
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 100),
            alertView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -100),
            alertView.heightAnchor.constraint(equalToConstant: 200),
            alertView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor)
        ])
        
        viewScreen.backgroundColor = .green
        viewScreen.frame = view.bounds
        viewScreen.makeSecure()

        view.addSubview(viewScreen)
         
        
        view.addSubview(viewRecording)
        viewRecording.isHidden = true
        viewRecording.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewRecording.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 100),
            viewRecording.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -100),
            viewRecording.heightAnchor.constraint(equalToConstant: 200),
            viewRecording.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor)
        ])
    }
    

    // Method called when screen capture status changes
    @objc func preventScreenRecording(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen else {
            return
        }
        
        if screen.isCaptured {
            // Screen recording has started, take appropriate action
            // For example, pause the app, hide sensitive content, or display a watermark
            viewRecording.isHidden = false
        } else {
            // Screen recording has stopped, resume normal app behavior
            // Undo any actions taken when recording started
            viewRecording.isHidden = true
        }
    }
}


extension UIView {
    func makeSecure() {
        DispatchQueue.main.async {
            let field = UITextField()
            field.isSecureTextEntry = true
            field.isUserInteractionEnabled = false
            self.addSubview(field)
            field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.first?.addSublayer(self.layer)
        }
    }
}
