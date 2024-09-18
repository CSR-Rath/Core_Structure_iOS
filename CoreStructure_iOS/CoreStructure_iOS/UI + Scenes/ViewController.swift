import UIKit

import UIKit


//class ViewControllerTesting: UIViewController {
//
//        
//        let customSegmentedControl = CustomSegmentedControl(frame: CGRect(x: 20,
//                                                                          y: 100,
//                                                                          width: 280,
//                                                                          height: 50),
//                                                             buttonTitles: ["First", "Second", "Third"])
//        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            view.backgroundColor = .white
//            
//            setupCustomSegmentedControl()
//        }
//        
//        private func setupCustomSegmentedControl() {
//
//            customSegmentedControl.cornerRadius = 5.0
//            customSegmentedControl.selectorHeight = 4.0
//            customSegmentedControl.font = UIFont.boldSystemFont(ofSize: 16)
//            view.addSubview(customSegmentedControl)
//        }
//    }




//class CustomSegmentedControl: UIView {
//    
//    private var buttonTitles: [String]!
//    private var buttons: [UIButton] = []
//    private var selectorView: UIView!
//    
//    var textColor: UIColor = .black
//    var selectedTextColor: UIColor = .red
//    var selectorViewColor: UIColor = .blue
//    var cornerRadius: CGFloat = 10.0
//    var selectorHeight: CGFloat = 4.0
//    var font: UIFont = UIFont.systemFont(ofSize: 16)
//    
//    public private(set) var selectedIndex: Int = 0
//    
//    convenience init(frame: CGRect, buttonTitles: [String]) {
//        self.init(frame: frame)
//        self.buttonTitles = buttonTitles
//        setupView()
//    }
//    
//    private func setupView() {
//        createButtons()
//        configureSelectorView()
//        configureStackView()
//    }
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        self.backgroundColor = .white
//    }
//    
//    private func createButtons() {
//        buttons.removeAll()
//        for title in buttonTitles {
//            let button = UIButton(type: .system)
//            button.setTitle(title, for: .normal)
//            button.setTitleColor(textColor, for: .normal)
//            button.titleLabel?.font = font
//            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
//            buttons.append(button)
//        }
//        buttons[0].setTitleColor(selectedTextColor, for: .normal) // Highlight the first button
//    }
//    
//    private func configureStackView() {
//        let stack = UIStackView(arrangedSubviews: buttons)
//        stack.axis = .horizontal
//        stack.alignment = .fill
//        stack.distribution = .fillEqually
//        addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: self.topAnchor),
//            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            stack.leftAnchor.constraint(equalTo: self.leftAnchor),
//            stack.rightAnchor.constraint(equalTo: self.rightAnchor)
//        ])
//    }
//    
//    private func configureSelectorView() {
//        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
//        selectorView = UIView(frame: CGRect(x: 0,
//                                            y: frame.height - selectorHeight,
//                                            width: selectorWidth,
//                                            height: selectorHeight))
//        selectorView.layer.cornerRadius = cornerRadius
//        selectorView.backgroundColor = selectorViewColor
//        addSubview(selectorView)
//    }
//    
//    @objc private func buttonAction(sender: UIButton) {
//        for (index, button) in buttons.enumerated() {
//            button.setTitleColor(textColor, for: .normal)
//            if button == sender {
//                selectedIndex = index
//                button.setTitleColor(selectedTextColor, for: .normal)
//                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
//                UIView.animate(withDuration: 0.3) {
//                    self.selectorView.frame.origin.x = selectorPosition
//                }
//                // Handle the segment change directly here
//                handleSegmentChange(index: selectedIndex)
//            }
//        }
//    }
//    
//    private func handleSegmentChange(index: Int) {
//        // Perform actions based on the selected index
//        print("Selected index: \(index)")
//    }
//    
//    func setIndex(index: Int) {
//        guard index < buttons.count else { return }
//        buttons.forEach { $0.setTitleColor(textColor, for: .normal) }
//        let button = buttons[index]
//        selectedIndex = index
//        button.setTitleColor(selectedTextColor, for: .normal)
//        let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
//        UIView.animate(withDuration: 0.3) {
//            self.selectorView.frame.origin.x = selectorPosition
//        }
//    }
//}


import UIKit

class CustomSegmentedControl: UIView {
    
     var buttonTitles: [String]!
    private var buttons: [UIButton] = []
    private var selectorView: UIView!
    
    var textColor: UIColor = .black
    var selectedTextColor: UIColor = .red
    var selectorViewColor: UIColor = .blue
    var cornerRadius: CGFloat = 10.0
    var selectorHeight: CGFloat = 4.0
    var font: UIFont = UIFont.systemFont(ofSize: 16)
    
    public private(set) var selectedIndex: Int = 0
    
    convenience init(frame: CGRect, buttonTitles: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitles
        setupView()
    }
    
    private func setupView() {
        createButtons()
        configureSelectorView()
        configureStackView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .white
    }
    
    private func createButtons() {
        buttons.removeAll()
        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = font
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectedTextColor, for: .normal) // Highlight the first button
    }
    
    private func configureStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.leftAnchor.constraint(equalTo: self.leftAnchor),
            stack.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    private func configureSelectorView() {
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0,
                                            y: frame.height - selectorHeight,
                                            width: selectorWidth,
                                            height: selectorHeight))
        selectorView.layer.cornerRadius = cornerRadius
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    @objc private func buttonAction(sender: UIButton) {
        for (index, button) in buttons.enumerated() {
            button.setTitleColor(textColor, for: .normal)
            if button == sender {
                selectedIndex = index
                button.setTitleColor(selectedTextColor, for: .normal)
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
            }
        }
    }
    
    func setIndex(index: Int) {
        guard index < buttons.count else { return }
        buttons.forEach { $0.setTitleColor(textColor, for: .normal) }
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectedTextColor, for: .normal)
        let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.3) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
}

import UIKit

class ViewControllerTesting: UIViewController {
    
    let customSegmentedControl = CustomSegmentedControl(frame: CGRect(x: 20, y: 100, width: 280, height: 50),
                                                         buttonTitles: ["First", "Second", "Third"])
    var pageViewController: UIPageViewController!
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCustomSegmentedControl()
        setupPageViewController()
    }
    
    private func setupCustomSegmentedControl() {
        customSegmentedControl.cornerRadius = 5.0
        customSegmentedControl.selectorHeight = 4.0
        customSegmentedControl.font = UIFont.boldSystemFont(ofSize: 16)
        // Add tap gesture recognizer
        customSegmentedControl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(segmentChanged(_:))))
        view.addSubview(customSegmentedControl)
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        // Create view controllers for each segment
        let firstVC = FirstViewController()
        let secondVC = SecondViewController()
        let thirdVC = ThirdViewController()
        viewControllers = [firstVC, secondVC, thirdVC]
        
        // Set the initial view controller
        if let firstViewController = viewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // Add the page view controller to the current view controller
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = CGRect(x: 0, y: 160, width: view.frame.width, height: view.frame.height - 160)
        pageViewController.didMove(toParent: self)
    }
    
    @objc private func segmentChanged(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: customSegmentedControl)
        let width = customSegmentedControl.frame.width / CGFloat(customSegmentedControl.buttonTitles.count)
        let index = Int(location.x / width)
        
        if index >= 0 && index < customSegmentedControl.buttonTitles.count {
            customSegmentedControl.setIndex(index: index)
            let selectedVC = viewControllers[index]
            let direction: UIPageViewController.NavigationDirection = index > customSegmentedControl.selectedIndex ? .forward : .reverse
            
            pageViewController.setViewControllers([selectedVC], direction: direction, animated: true, completion: nil)
        }
    }
}

//class FirstViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .red
//    }
//}
//
//class SecondViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .green
//    }
//}

class ThirdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
