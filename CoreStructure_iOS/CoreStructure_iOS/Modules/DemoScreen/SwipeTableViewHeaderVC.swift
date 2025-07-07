//
//  SwipeTableViewHeaderVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/2/25.
//

import UIKit

class SwipeTableViewHeaderVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var sections = ["Section 1", "Section 2", "Section 3"] // Sample data
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize TableView
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        view.addSubview(tableView)
    }
    
    // MARK: - TableView Data Source & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
    
    // MARK: - Custom Header View
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomSwipeHeaderView()
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
}

// MARK: - Custom Header View



//    // MARK: - Handle Delete Action
extension SwipeTableViewHeaderVC: CustomHeaderViewDelegate {
    func didSwipeToDeleteSection(_ section: Int) {
        print("Deleting section \(section)")
        sections.remove(at: section)
        tableView.reloadData()
    }
}

protocol CustomHeaderViewDelegate: AnyObject {
    func didSwipeToDeleteSection(_ section: Int)
}

class CustomSwipeHeaderView: UIView {
    
    weak var delegate: CustomHeaderViewDelegate? // Use protocol
    
    private let deleteButton = UIButton()
    private var section: Int = 0
    private var isSwiped = false
    private let widthButton: CGFloat = 75
    
    lazy var bgView: ItemsListView = {
        let view = ItemsListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSwipeGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(resetSwipe), name: NSNotification.Name("ResetSwipeNotification"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addSwipeGesture()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetSwipe),
                                               name: NSNotification.Name("ResetSwipeNotification"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
//        deleteButton.setImage(UImage., for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        self.addSubview(bgView)
        self.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bgView.leftAnchor.constraint(equalTo: leftAnchor),
            bgView.rightAnchor.constraint(equalTo: rightAnchor),

            deleteButton.widthAnchor.constraint(equalToConstant: widthButton),
            deleteButton.topAnchor.constraint(equalTo: topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthButton),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func addSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipeLeft() {
        if !isSwiped {
            // Post a notification to reset other swiped views
            NotificationCenter.default.post(name: NSNotification.Name("ResetSwipeNotification"), object: nil)

            isSwiped = true
            UIView.animate(withDuration: 0.3) {
                self.deleteButton.frame.origin.x = self.frame.width - self.widthButton
                self.bgView.frame.origin.x = -50 - 20
            }
        }
    }
    
    @objc private func handleSwipeRight() {
        resetSwipe()
    }
    
    @objc private func resetSwipe() {
        if isSwiped {
            isSwiped = false
            UIView.animate(withDuration: 0.3) {
                self.deleteButton.frame.origin.x = self.frame.width
                self.bgView.frame.origin.x = 0
            }
        }
    }
    
    @objc private func deleteTapped() {
        delegate?.didSwipeToDeleteSection(section)
    }
}


class ItemsListView: UIView {

    static let identifier  = "ItemsTableViewCell"
    
    var didTappedButtonPlus : (()->())?
    var didTappedButtonMinus : (()->())?
    lazy var imgItem : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        img.image = .imgQRCode
        return img
    }()
    
    lazy var  lblTitle : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.fontBold(14)
        lbl.text = "_"
        return lbl
    }()
    
    lazy var  lblPrice : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.fontRegular(14)
        return lbl
    }()

    lazy var  lblPoint : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.fontRegular(14)
        return lbl
    }()
    
    let stackViewPrice  = UIStackView()
    let stackViewButton = UIStackView()
    
    lazy var lineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy  var minusButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setImage(UIImage.icMinus, for: .normal)
        btn.addTarget(self, action: #selector(self.didTapButtonMinus(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var plusButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setImage(UIImage.icPlus, for: .normal)
        btn.addTarget(self, action: #selector(self.didTapButtonPlus(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var countLabel: UITextField = {
        let lbl = UITextField()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.keyboardType = .numberPad
        lbl.text = "1"
        
//        if Localize.currentLanguage() == "en"{
//            lbl.font = UIFont(name: Environment.English_BOLD, size: 17)
//        }else{
//            lbl.font = UIFont(name: Environment.KHMER_BOLD, size: 17)
//        }
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButtonPlus(_ sender : UIButton){
        self.didTappedButtonPlus?()
    }
    
    @objc func didTapButtonMinus(_ sender : UIButton){
        self.didTappedButtonMinus?()
    }
    
    func setupView(){


       


        lblPrice.text = "Price: "
        lblPoint.text = "Point: "
        stackViewPrice.addArrangedSubview(lblPrice)
        stackViewPrice.addArrangedSubview(lblPoint)
        stackViewPrice.axis = .horizontal
        stackViewPrice.spacing = 20
        stackViewPrice.translatesAutoresizingMaskIntoConstraints = false
        
        stackViewButton.addArrangedSubview(minusButton)
        stackViewButton.addArrangedSubview(countLabel)
        stackViewButton.addArrangedSubview(plusButton)
        stackViewButton.axis = .horizontal
        stackViewButton.spacing = 0

        stackViewButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackViewButton)
        addSubview(imgItem)
        addSubview(lblTitle)
        addSubview(lineView)
        addSubview(stackViewPrice)
        addSubview(stackViewButton)
        
        NSLayoutConstraint.activate([
        
            self.imgItem.topAnchor.constraint(equalTo: topAnchor, constant: .mainLeft),
            self.imgItem.bottomAnchor.constraint(equalTo: bottomAnchor, constant: .mainRight),
            self.imgItem.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mainLeft),
            self.imgItem.heightAnchor.constraint(equalToConstant: 70),
            self.imgItem.widthAnchor.constraint(equalToConstant: 70),
            
            self.lblTitle.topAnchor.constraint(equalTo: self.imgItem.topAnchor, constant: 3),
            self.lblTitle.leadingAnchor.constraint(equalTo: imgItem.trailingAnchor, constant: 8),
            
            stackViewPrice.bottomAnchor.constraint(equalTo: imgItem.bottomAnchor, constant: -3),
            stackViewPrice.leadingAnchor.constraint(equalTo: imgItem.trailingAnchor, constant: 8),
            
            stackViewButton.topAnchor.constraint(equalTo: imgItem.topAnchor, constant: 0),
            stackViewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .mainRight),
            stackViewButton.widthAnchor.constraint(equalToConstant: 105),
            self.lblTitle.trailingAnchor.constraint(equalTo: stackViewButton.leadingAnchor, constant: -5),
 
            self.lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            self.lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            self.lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            self.lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            minusButton.heightAnchor.constraint(equalToConstant: 32),
            minusButton.widthAnchor.constraint(equalToConstant: 32),
            plusButton.heightAnchor.constraint(equalToConstant: 32),
            plusButton.widthAnchor.constraint(equalToConstant: 32),
        ])
    }
}



class ProfileViewController: UIViewController {
   

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            
            print("Current Language: \(Locale.current.languageCode ?? "unknown")")
            print("Layout Direction: \(UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .rightToLeft ? "RTL" : "LTR")")
        
            
            // Label using trailingAnchor (Moves in RTL)
            let trailingLabel = createLabel(text: "Using trailingAnchor", backgroundColor: .green)
            view.addSubview(trailingLabel)
            
            // Label using rightAnchor (Always on the right)
            let rightLabel = createLabel(text: "Using rightAnchor", backgroundColor: .blue)
            view.addSubview(rightLabel)
            
            NSLayoutConstraint.activate([
                // Position trailingLabel using trailingAnchor (Moves in RTL)
                trailingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                trailingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
                trailingLabel.widthAnchor.constraint(equalToConstant: 200),
                trailingLabel.heightAnchor.constraint(equalToConstant: 50),
                
                // Position rightLabel using rightAnchor (Stays fixed)
                rightLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                rightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
                rightLabel.widthAnchor.constraint(equalToConstant: 200),
                rightLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        func createLabel(text: String, backgroundColor: UIColor) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.backgroundColor = backgroundColor
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
    }
