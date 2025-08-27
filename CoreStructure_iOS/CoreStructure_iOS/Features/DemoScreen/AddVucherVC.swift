//
//  AddVucherVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/2/25.
//

import UIKit

extension AddVoucherView: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        return cell
    }
}


class AddVoucherVC: BaseUIViewConroller {
    private let addVoucherView = AddVoucherView()
    
    override func loadView() {
        view = addVoucherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addVoucherView.actionDismiss = {
            self.dismissVC()
        }
    }
}

class AddVoucherView: UIView {
    var actionDismiss: (() -> Void)?
    
    // MARK: - UI Components
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .mainColor // f5f5
        view.clipsToBounds = true
        return view
    }()
    
    private let viewLineTop: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let lblName: UILabel = {
        let label = UILabel()
        label.text = "Add Voucher"
        label.textColor = .black
        label.fontBold(16)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // MARK: - Layout Constraints
    private let defaultHeight: CGFloat = UIScreen.main.bounds.height * 0.7
    private let dismissibleHeight: CGFloat = 300
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = 600
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupUI()
        setupConstraints()
        setupGestures()
        animatePresentContainer()
    }
    
    private func setupUI() {
        addSubview(dimmedView)
        addSubview(containerView)
        containerView.addSubview(viewLineTop)
        containerView.addSubview(lblName)
        containerView.addSubview(tableView)
    }
    
    private func setupConstraints() {
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        viewLineTop.translatesAutoresizingMaskIntoConstraints = false
        lblName.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            viewLineTop.heightAnchor.constraint(equalToConstant: 4),
            viewLineTop.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            viewLineTop.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13),
            viewLineTop.widthAnchor.constraint(equalToConstant: 65),
            
            lblName.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            lblName.topAnchor.constraint(equalTo: viewLineTop.bottomAnchor, constant: 24),
            
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: .mainLeft),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: .mainRight),
            tableView.topAnchor.constraint(equalTo: lblName.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: .mainRight),
            
        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Actions
    @objc private func handleCloseAction() {
        animateDismissView()
    }
    
    // MARK: - Gesture Handling
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let newHeight = currentContainerHeight - translation.y
        let isDraggingDown = translation.y > 0
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                self.layoutIfNeeded()
            }
        case .ended:
            handlePanEnd(newHeight: newHeight, isDraggingDown: isDraggingDown)
        default:
            break
        }
    }
    
    private func handlePanEnd(newHeight: CGFloat, isDraggingDown: Bool) {
        if newHeight < dismissibleHeight {
            animateDismissView()
        } else if newHeight < defaultHeight {
            animateContainerHeight(defaultHeight)
        } else if isDraggingDown {
            animateContainerHeight(defaultHeight)
        } else {
            animateContainerHeight(maximumContainerHeight)
        }
    }
    

    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraint?.constant = height
            self.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.05) {
            self.containerViewBottomConstraint?.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    @objc private func animateDismissView() {
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.layoutIfNeeded()
        } completion: { _ in
            self.actionDismiss?()
        }
    }
}


class TestingVC : UIViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = AddVoucherVC()
        vc.transitioningDelegate = presentVC
        vc.modalPresentationStyle = .custom
        present(vc, animated: true) {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .gray
    }
    
}
