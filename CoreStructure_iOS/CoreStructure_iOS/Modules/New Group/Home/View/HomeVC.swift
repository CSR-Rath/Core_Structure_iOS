//
//  HomeVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/9/24.
//

import UIKit


enum IsRefreshFuncion{
    
    case isWallet
    case isUserInfor
    case isRefreshData
    case isNone
    
}


var isRefreshFuncion: IsRefreshFuncion = .isNone

//class HomeVC: UIViewController {
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        makeRefreshData()
//    
//        
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        getData()
//    }
//    
//    private func makeRefreshData(){
//        //MARK: Handle Refresh data when didchange base only one function
//        switch isRefreshFuncion{
//            
//        case .isWallet:
//            isRefreshFuncion = .isNone
//            
//            getWallet(){
//                
//            }
//            
//        case .isUserInfor:
//            isRefreshFuncion = .isNone
//            
//            gerUserInfor()
//            
//            
//        case .isRefreshData:
//            
//            isRefreshFuncion = .isNone
//            
//        case .isNone:
//            
//            isRefreshFuncion = .isNone
//            break
//        }
//    }
//    
//    
//    private func getData(){
//        
//        getWallet {
//            self.gerUserInfor()
//        }
//    }
//    
//    private func getWallet(success: @escaping () -> Void){
//        
//        HomeVM.getWalet { response in
//            success()
//            
//        }
//        
//    }
//    
//    private func gerUserInfor(){
//        
//        HomeVM.getUserInfor(success: { response in
//            
//        })
//    }
//    
//}

class HomeVC: UIViewController{
    
    let homeView = HomeView()
    
    override func loadView() {
        super.loadView()
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}

class HomeView: UIView{
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .gray
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}


extension HomeView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
}


// MARK: Constraint
extension HomeView{
    
    
    private func setupUI(){
        addSubview(tableView)
        
        let more = MoreView()
        more.translatesAutoresizingMaskIntoConstraints = false
//        more.heightView = 200
        addSubview(more)
        
        NSLayoutConstraint.activate([
            more.leftAnchor.constraint(equalTo: leftAnchor),
            more.rightAnchor.constraint(equalTo: rightAnchor),
            more.centerYAnchor.constraint(equalTo: centerYAnchor),

            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        ])
    }
}



import UIKit

class StretchyHeaderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    let headerHeight: CGFloat = 300.0
    var headerView:  UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupHeaderView()
    }

    func setupTableView() {
        // Initialize and configure the table view
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Set content inset for the header
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        // Add table view to the view controller's view
        view.addSubview(tableView)
    }

    func setupHeaderView() {
        // Initialize the header view
        headerView = UIView(frame: CGRect(x: 0, y: -headerHeight,
                                          width: tableView.frame.width,
                                          height: headerHeight))
        headerView.backgroundColor = .systemBlue
        
        let label = UILabel(frame: headerView.bounds)
        label.text = "Stretchy Header"
        label.textColor = .white
        label.textAlignment = .center
        headerView.addSubview(label)
        
        // Add the header view as a subview of the table view
        tableView.addSubview(headerView)
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50 // Example row count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + headerHeight
        
        if let headerView = headerView{
            if offsetY < 0 {
                // Stretch the header
                headerView.frame = CGRect(x: 0, y: offsetY, width: tableView.frame.width, height: headerHeight - offsetY)
            } else {
                // Reset header position
                headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)
            }
        }

    }
}
