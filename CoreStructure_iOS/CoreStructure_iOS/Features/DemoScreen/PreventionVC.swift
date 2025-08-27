import UIKit

class PreventionScreenVC: BaseUIViewConroller {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Prevent Screen"
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
        
        let viewScreen = UIView()
        viewScreen.backgroundColor = .green
        viewScreen.frame = view.bounds
        view.addSubview(viewScreen)
//        viewScreen.makeSecure()

    }
}

