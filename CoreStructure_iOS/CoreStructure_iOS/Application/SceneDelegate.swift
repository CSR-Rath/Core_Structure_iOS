//
//  SceneDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit

let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
let windowDelegate = sceneDelegate?.window

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.rootViewController()
        
    }
    
    private func rootViewController(){
     
        let controller: UIViewController = SlideshowViewController()
        let navigation = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
    }
}



import UIKit
import Combine

class MyViewController: UIViewController {
    
    private var textField = UITextField()
    private var label = UILabel()
    private var button = UIButton()
    
    private var cancellables = Set<AnyCancellable>() // Store subscriptions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Configure textField
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text"
        
        // Configure label
        label.textAlignment = .center
        label.textColor = .black
        
        // Configure button
        button.setTitle("Tap Me", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        // Add subviews
        view.addSubview(textField)
        view.addSubview(label)
        view.addSubview(button)
        
        // Layout using Auto Layout
        textField.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        // Binding UITextField input to UILabel
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, 
                                             object: textField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] text in
                self?.label.text = text
            }
            .store(in: &cancellables)

        // Button tap action using Combine
        button.publisher(for: .touchUpInside)
            .sink { [weak self] in
                print("Button tapped!")
                self?.label.text = "Button Clicked!"
            }
            .store(in: &cancellables)
    }
}



extension UIControl {
    func publisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
        let subject = PassthroughSubject<Void, Never>()
        addTarget(self, action: #selector(trigger(_:)), for: event)
        
        return subject.eraseToAnyPublisher()
    }
    
    @objc private func trigger(_ sender: UIControl) {
        (sender as? UIButton)?.sendActions(for: .touchUpInside)
    }
}



extension SceneDelegate{
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
    }
    
}



// SwiftUI is have func (onAppear and onDisappear) = (viewWillAppear or viewDidAppear) and (viewWillDisappear or viewDidDisappear or viewDidload)
