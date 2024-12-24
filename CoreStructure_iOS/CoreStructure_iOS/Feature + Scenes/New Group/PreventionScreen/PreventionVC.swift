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
        view.backgroundColor = .black
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
        view.addSubview(viewScreen)
        viewScreen.makeSecure()

    }
}

