//
//  SliderMenuVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 21/8/24.
//

import UIKit

class SliderMenuVC: UIViewController {

        
        
        private let widht: CGFloat = 360
        private var menuIsOpen = false
        private let menuViewController = MenuViewController()

        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            
            let test = UIButton(frame: CGRect(x: 400, y: 100, width: 100, height: 40))
            test.setTitle("Menu", for: .normal)
            test.backgroundColor = .red
            view.addSubview(test)
            
            // Add a button to open the menu (optional)
            let menuButton = UIButton(frame: CGRect(x: 400, y: 200, width: 100, height: 40))
            menuButton.setTitle("Menu", for: .normal)
            menuButton.backgroundColor = .blue
            menuButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
            
            view.addSubview(menuButton)
            
            setupMenu()
            addPanGesture()
            
            
        }
        
        private func setupMenu() {
            addChild(menuViewController)
            view.addSubview(menuViewController.view)
            // Set initial frame; width can vary based on orientation
            menuViewController.view.frame = CGRect(x: -widht, y: 0,
                                                   width: widht, height: view.frame.height)
            menuViewController.didMove(toParent: self)
        }
        
        private func addPanGesture() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            view.addGestureRecognizer(panGesture)
        }
        
        var isOpenScroll : Bool = false
        
        @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: view)
            let currentX = menuViewController.view.frame.origin.x
            let threshold: CGFloat = 140
            
            switch gesture.state {
            case .changed:
                
                let newPosition: CGFloat
                
                // Ensure the new position is within the bounds of -width and 0
                newPosition = min(0, max(currentX + translation.x, -widht))
                
                menuViewController.view.frame.origin.x = newPosition
                gesture.setTranslation(.zero, in: view)
                
                
            case .ended:
                
                
                print("currentX == > \(currentX)")
                
                
                if menuIsOpen{ // handle when open menu slider
                    
                    // Determine if the menu should open or close
                    if currentX > -threshold {
                        // Open the menu if it's swiped sufficiently to the right
                        openMenu()
                    } else {
                        // Close the menu if it's not swiped enough
                        closeMenu()
                    }
                    
                    
                }else{
                    
                    let threshold: CGFloat = widht-threshold //
                    
                    // Determine if the menu should open or close
                    if currentX > -threshold {
                        // Open the menu if it's swiped sufficiently to the right
                        openMenu()
                    } else {
                        // Close the menu if it's not swiped enough
                        closeMenu()
                    }
                }
                
                
            default:
                break
            }
        }
        
        private func handlePanEnd() {
            let threshold: CGFloat = 120
            
            if menuIsOpen {
                // If menu is open, check if it should be closed
                if menuViewController.view.frame.origin.x < -threshold {
                    closeMenu()
                } else {
                    openMenu()
                }
            } else {
                // If menu is closed, check if it should be opened
                if menuViewController.view.frame.origin.x > threshold {
                    openMenu()
                } else {
                    closeMenu()
                }
            }
        }
        
        
        @objc private func toggleMenu() {
            menuIsOpen.toggle()
            let targetPosition: CGFloat = menuIsOpen ? 0 : -widht
            
            
            UIView.animate(withDuration: 0.1) { [self] in
                self.menuViewController.view.frame.origin.x = targetPosition
            }
        }
        

     
        private func openMenu() {
            menuIsOpen = true
            //  withDuration = Speed open menu slider
            UIView.animate(withDuration: 0.1) { [self] in
                self.menuViewController.view.frame.origin.x = 0
                
            }
        }
        
        private func closeMenu() {
            menuIsOpen = false
            //  withDuration = Speed close menu slider
            UIView.animate(withDuration: 0.1) { [self] in
                self.menuViewController.view.frame.origin.x = -widht
            }
        }
        
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            
            coordinator.animate(alongsideTransition: { [self] _ in
                // Update the menu's frame during the transition
                self.menuViewController.view.frame.size.height = size.height
                
                // Adjust the width of the menuViewController (if needed)
                let newWidth: CGFloat = widht // Modify this if you want a different width based on orientation
                self.menuViewController.view.frame.size.width = newWidth
                
                // Optionally reposition the menu if it's open
                if self.menuIsOpen {
                    self.menuViewController.view.frame.origin.x = 0
                } else {
                    self.menuViewController.view.frame.origin.x = -newWidth
                }
                menuViewController.view.animateHide()
            }, completion: { [self]_ in
                menuViewController.view.animateShow()
            })
        }
    }



    class MenuViewController: UIViewController {
        
        lazy var tableView: UITableView = {
            let table = UITableView()
            table.backgroundColor = .orange
            table.separatorStyle = .none
            table.dataSource = self
            table.delegate = self
            table.showsVerticalScrollIndicator = false
            table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            return table
        }()
        
        lazy var lblVersion: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = "Version 1.0.0"
            lbl.textColor = .white
            lbl.backgroundColor = .red
            lbl.textAlignment = .center
            return lbl
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .orange
            
            view.addSubview(lblVersion)
            lblVersion.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                lblVersion.heightAnchor.constraint(equalToConstant: 80),
                lblVersion.leftAnchor.constraint(equalTo: view.leftAnchor),
                lblVersion.rightAnchor.constraint(equalTo: view.rightAnchor),
                lblVersion.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: lblVersion.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
        }
    }

    extension MenuViewController : UITableViewDataSource, UITableViewDelegate{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .clear
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    }





import UIKit

class CustomSlider: UIView {
    
    private let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.layer.cornerRadius = 15
        return view
    }()
    
    var value: CGFloat = 0 {
        didSet {
            // Update the position of the thumbView based on the value
            let sliderWidth = self.bounds.width - thumbView.bounds.width
            thumbView.center.x = sliderWidth * value + thumbView.bounds.width / 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSlider()
    }
    
    private func setupSlider() {
        self.backgroundColor = .lightGray
        self.addSubview(thumbView)
        
        // Add pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        thumbView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        // Move the thumbView
        thumbView.center.x += translation.x
        
        // Constrain thumbView within the slider bounds
        if thumbView.center.x < thumbView.bounds.width / 2 {
            thumbView.center.x = thumbView.bounds.width / 2
        } else if thumbView.center.x > bounds.width - thumbView.bounds.width / 2 {
            thumbView.center.x = bounds.width - thumbView.bounds.width / 2
        }
        
        // Reset translation to zero
        gesture.setTranslation(.zero, in: self)
        
        // Calculate slider value
        let sliderWidth = bounds.width - thumbView.bounds.width
        value = (thumbView.center.x - thumbView.bounds.width / 2) / sliderWidth
        
        // Optional: Notify value change
        print("Slider Value: \(value)")
    }
}

// Usage in a ViewController
class ViewController: UIViewController {
    
    private let customSlider = CustomSlider()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        // Setup the slider frame
        customSlider.frame = CGRect(x: 50, y: 200, width: 300, height: 30)
        view.addSubview(customSlider)
    }
}
