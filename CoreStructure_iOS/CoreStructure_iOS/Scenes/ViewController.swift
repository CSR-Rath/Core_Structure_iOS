import UIKit


class VisitCommercialVC: UIViewController {
    // define lazy views
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "The Real Reward".uppercased()
        label.fontBold(16)
        label.textColor = .white
        return label
    }()
    
    lazy var containerView: BlurredBackgroundView = {
        let view = BlurredBackgroundView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.backgroundColor = .mainColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var  maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    lazy var bgQRCode: UIView = {
//        let bgView = UIView()
//        bgView.translatesAutoresizingMaskIntoConstraints = false
//        bgView.backgroundColor = .orange
//        bgView.layer.cornerRadius = 10
//        bgView.clipsToBounds = true
//        return bgView
//    }()
    
    lazy var imgQR: UIImageView = {
        let  img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setImageColor(color: .black)
        img.backgroundColor = .white
        img.layer.borderColor = UIColor.white.cgColor
        img.contentMode = .scaleAspectFill
        return img
    }()

//    lazy var bgQRCodeWhite: UIView = {
//        let  img = UIView()
//        img.translatesAutoresizingMaskIntoConstraints = false
//        img.backgroundColor = .white
//        img.layer.cornerRadius = 10
//        return img
//    }()

    lazy var topLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
//    lazy var topQRCodeView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .orange
//        return view
//    }()
    
    lazy var btnVisit: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Visit", for: .normal)
        return btn
    }()
    

    // Constants
    let defaultHeight: CGFloat = 466
    let dismissibleHeight: CGFloat = 466 - 130
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 466 // need = defaultHeight
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    var containerReloading: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        setupConstraints()
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        setupPanGesture()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func getdata() {
//        PointReceiveViewModel().generateQRRequest { response in
//
//            DispatchQueue.main.async {
//                let value = response.results ?? ""
//
//                let QRImage = self.view.generateQRCode(from: "the-real-reward://" + value )
//                self.imgQR.image = QRImage
//                self.imgQR.alpha = 1
////                self.viewPresent.bringSubviewToFront(self.imgLogo)
//                Loading.shared.hideLoading()
//            }
//        }
    }
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(topLineView)
        containerView.addSubview(imgQR)




        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // content stackView
            
           
            topLineView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            topLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 5),
            topLineView.widthAnchor.constraint(equalToConstant: 36),
            
            imgQR.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            imgQR.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            imgQR.topAnchor.constraint(equalTo: containerView.topAnchor),
            imgQR.heightAnchor.constraint(equalToConstant: 205),

        ])
        
    
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)

        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        let pannedHeight = translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                
                
                
                
                
                if newHeight < defaultHeight{
//                    containerReloading?.isActive = false
//                    containerReloading = bgQRCode.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 65)
//                    containerReloading?.isActive = true
                    
                    // Update the currentMaxDimmedAlpha based on the panned height
                    
                    let progress = pannedHeight / defaultHeight
                    self.maxDimmedAlpha = 0.6 * (1 - progress)
                    self.dimmedView.alpha = self.maxDimmedAlpha

                    
                }else{
                    self.maxDimmedAlpha = 0.6
//                    containerReloading?.isActive = false
//                    containerReloading = bgQRCode.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
//                    containerReloading?.isActive = true
                }
                
                containerViewHeightConstraint?.constant = newHeight
                
                // refresh layout
                view.layoutIfNeeded()
            }else{
                

                view.layoutIfNeeded()
                print("newHeight \(newHeight)")
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                print("newHeight| ===> (newHeight)")
                
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    @objc func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
}
