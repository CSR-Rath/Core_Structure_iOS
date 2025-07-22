//
//  BaseViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 17/3/25.
//
import UIKit

// MARK: - BaseViewController
class BaseViewController: UIViewController {
    
    // MARK: - Properties
    var isBackBarItemButton: Bool = false
    {
        didSet{
            setupUI()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    func setupUI() {
        view.backgroundColor = .mainColor
        if isBackBarItemButton {
            setupBackButton()
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func setupConstraints() {
        // To be overridden by subclasses
    }
    
    
    
    private func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    deinit{
        print("🔴 BaseViewController is working deinit")
        
    }
}

struct AvailableServiceModel{
    let id: Int
    let titleName: String
    let iConName: String
}

// MARK: - Example Usage
class HomeViewController: BaseViewController {
    
    var availableService: [AvailableServiceModel] = []
    
    let topView = UIView()
    let viewFuelRate = UIView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .mainColor
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
        tableView.sectionHeaderTopPadding = 0
        }
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isBackBarItemButton = true
    }
    
    override func setupUI() {
        super.setupUI()
        topView.backgroundColor = .mainYellow
    }
    
    override func setupConstraints() {
        
        let stack = UIStackView(arrangedSubviews: [topView, tableView] )
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        stack.frame = self.view.bounds
        
        viewFuelRate.layer.cornerRadius = 10
        viewFuelRate.backgroundColor = .mainLightColor
        viewFuelRate.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews(of: stack, viewFuelRate)
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 155),
            
            viewFuelRate.heightAnchor.constraint(equalToConstant: 55),
            viewFuelRate.centerYAnchor.constraint(equalTo: tableView.topAnchor),
            viewFuelRate.leftAnchor.constraint(equalTo: view.leftAnchor,constant: .mainLeft),
            viewFuelRate.rightAnchor.constraint(equalTo: view.rightAnchor,constant: .mainRight),
        ])
    }
}

//MARK: - AvailableServiceModel
extension HomeViewController{
//    func setAvailableServiceModel(){
//        AppManager.shared.getAccountTypes { accountType in
//            switch accountType{
//            case .generalAccount:
//                
//                self.availableService = [
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                ]
//                
//            case .counterAccount:
//                
//                self.availableService = [
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                ]
//
//            case .stationAccount:
//                
//                self.availableService = [
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                ]
//
//            case .cooperateAccount:
//                
//                self.availableService = [
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                    AvailableServiceModel(id: 1, titleName: "", iConName: ""),
//                ]
//            }
//        }
//    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell0 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        let allCell = [cell0,cell1,cell2,cell3]
//        
//        allCell.forEach({ item in
//            item.backgroundColor = .clear
//            item.selectionStyle = .none
//            
//        })
//
//        switch indexPath.section {
//        case 0:// upgrade account
//            
//            AppManager.shared.getAccountTypes { accountType in
//                switch accountType{
//                case .generalAccount:
//                    
//                    print("accountType")
//                case .counterAccount:
//                    
//                    print("accountType")
//                case .stationAccount:
//                    
//                    print("accountType")
//                case .cooperateAccount:
//                    
//                    print("accountType")
//                }
//            }
//            
//           
//        case 1:// Fuel Balance
//            
//            AppManager.shared.getAccountTypes { accountType in
//                switch accountType{
//                case .generalAccount:
//                    
//                    print("accountType")
//                case .counterAccount:
//                    
//                    print("accountType")
//                case .stationAccount:
//                    
//                    print("accountType")
//                case .cooperateAccount:
//                    
//                    print("accountType")
//                }
//            }
//            
//
//        case 2:// Avaiable Service
//            
//            AppManager.shared.getAccountTypes { accountType in
//                switch accountType{
//                case .generalAccount:
//                    
//                    print("accountType")
//                case .counterAccount:
//                    
//                    print("accountType")
//                case .stationAccount:
//                    
//                    print("accountType")
//                case .cooperateAccount:
//                    
//                    print("accountType")
//                }
//            }
//            
//        case 3:// News
//            
//            AppManager.shared.getAccountTypes { accountType in
//                switch accountType{
//                case .generalAccount:
//                    
//                    print("accountType")
//                case .counterAccount:
//                    
//                    print("accountType")
//                case .stationAccount:
//                    
//                    print("accountType")
//                case .cooperateAccount:
//                    
//                    print("accountType")
//                }
//            }
//
//        default:
//            print("Another Selection")
//        }
//        
        return cell2// allCell[indexPath.section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = UIView()
        viewHeader.backgroundColor = .clear
        
        let labelTitleName = UILabel()
        labelTitleName.translatesAutoresizingMaskIntoConstraints = false
        labelTitleName.text = "Title"
        labelTitleName.textColor = .white
        viewHeader.addSubview(labelTitleName)

        NSLayoutConstraint.activate([
        
            labelTitleName.leftAnchor.constraint(equalTo: viewHeader.leftAnchor,constant: .mainLeft),
            labelTitleName.rightAnchor.constraint(equalTo: viewHeader.rightAnchor,constant: .mainRight),
            
            labelTitleName.topAnchor.constraint(equalTo: viewHeader.topAnchor,constant: 0),
            labelTitleName.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor,constant: 0),
        
        ])
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
