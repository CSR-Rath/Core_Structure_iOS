import UIKit

// MARK: - Custom Segment Control

protocol CustomSegmentedControlDelegate: AnyObject {
    func customSegmentedControlDidChange(selectedIndex: Int)
}

class CustomSegmentedControl: UIView {

    weak var delegate: CustomSegmentedControlDelegate?
    
    private var buttons: [UIButton] = []
    private var selectedIndex: Int = 0 {
        didSet {
            updateButtonSelection()
            delegate?.customSegmentedControlDidChange(selectedIndex: selectedIndex)
        }
    }

    var segmentTitles: [String] = [] {
        didSet {
            setupButtons()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    private func setupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for title in segmentTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        layoutButtons()
        updateButtonSelection()
    }

    private func layoutButtons() {
        let buttonWidth = frame.width / CGFloat(buttons.count)
        for (index, button) in buttons.enumerated() {
            button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: frame.height)
            button.tag = index
        }
    }

    private func updateButtonSelection() {
        for (index, button) in buttons.enumerated() {
            button.isSelected = index == selectedIndex
            button.backgroundColor = button.isSelected ? .blue : .clear
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutButtons()
    }
}

// MARK: - Header View

protocol HeaderViewDelegate: AnyObject {
    func headerViewDidChangeSegment(to index: Int)
}

class HeaderView: UIView, CustomSegmentedControlDelegate {

    weak var delegate: HeaderViewDelegate?
    private var segmentedControl: CustomSegmentedControl! = nil

    override init(frame: CGRect) {
        segmentedControl = CustomSegmentedControl()
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .lightGray

        segmentedControl.segmentTitles = ["Page 1", "Page 2", "Page 3", "PagePagePagePagePagePage 4", "Page 5"]
        segmentedControl.delegate = self
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - CustomSegmentedControlDelegate
    
    func customSegmentedControlDidChange(selectedIndex: Int) {
        delegate?.headerViewDidChangeSegment(to: selectedIndex)
    }
}

// MARK: - Content View Controller

class ContentViewController: UIViewController {

    var labelText: String? {
        didSet {
            label.text = labelText
        }
    }
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 28)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabel()
    }
    
    private func setupLabel() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Main View Controller

class SelfSizingViewController: UIViewController, UIPageViewControllerDataSource, HeaderViewDelegate {

    var pageViewController: UIPageViewController!
    var contentViewControllers: [ContentViewController] = []
    private let headerView = HeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupPageViewController()
        setupContentViewControllers()
        displayInitialViewController()
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        headerView.delegate = self
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        // Adjust the frame to account for the header height
        pageViewController.view.frame = CGRect(
            x: 0,
            y: 60, // Height of the header
            width: view.bounds.width,
            height: view.bounds.height - 60 // Remaining height
        )
        
        pageViewController.didMove(toParent: self)
    }
    
    private func setupContentViewControllers() {
        for index in 0..<5 {
            let vc = ContentViewController()
            vc.labelText = "Page \(index + 1)"
            contentViewControllers.append(vc)
        }
    }
    
    private func displayInitialViewController() {
        if let firstVC = contentViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = contentViewControllers.firstIndex(of: viewController as! ContentViewController), currentIndex > 0 else {
            return nil
        }
        return contentViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = contentViewControllers.firstIndex(of: viewController as! ContentViewController), currentIndex < contentViewControllers.count - 1 else {
            return nil
        }
        return contentViewControllers[currentIndex + 1]
    }

    // MARK: - HeaderViewDelegate
    
    func headerViewDidChangeSegment(to index: Int) {
        let selectedVC = contentViewControllers[index]
        let currentVC = pageViewController.viewControllers?.first as? ContentViewController
        let direction: UIPageViewController.NavigationDirection = (currentVC == selectedVC) ? .forward : (contentViewControllers.firstIndex(of: selectedVC)! > contentViewControllers.firstIndex(of: currentVC!)!) ? .forward : .reverse

        pageViewController.setViewControllers([selectedVC], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - App Delegate

