//
//  DemoFeatureVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit

struct ListModel{
    let id: Int
    let name: String
    let viewController: UIViewController?
}

class DemoFeatureVC: UIViewController {
    
    private var tableView: UITableView! = nil
    
    var currentPage: Int = 0
    var totalList: Int = 0

    var items : [ListModel] = []{
        didSet{
            tableView.reloadData()
            tableView.endRefreshing()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent // or .default based on your needs
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        pullRefresh()
    }
    
    private func setupConstraint(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight = 60
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.addRefreshControl(target: self, action: #selector(pullRefresh))
        
    }
    
    @objc private func pullRefresh(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [self] in
            
            items =   [
                
                ListModel(id: 2, name: "PasscodeVC", viewController: PasscodeVC()),
                ListModel(id: 3, name: "OTPVC", viewController: OTPVC()),
                ListModel(id: 4, name: "BoardCollectionVC", viewController: BoardCollectionVC()),
                ListModel(id: 6, name: "CenteringCollectionViewCellVC", viewController: CenteringCellVC()),
                ListModel(id: 7, name: "Cell Alert Error", viewController: nil),
                ListModel(id: 9, name: "GroupDateVC", viewController: GroupDateVC()),
                ListModel(id: 10, name: "ExspandTableVC", viewController: ExspandTableVC()),
                ListModel(id: 11, name: "DragDropCollectionVC", viewController: DragDropCollectionVC()),
                ListModel(id: 12, name: "ButtonOntheKeyboradVC", viewController: ButtonOntheKeyboradVC()),
                ListModel(id: 13, name: "HandleNavigationBarVC", viewController: HandleNavigationBarVC()),
                ListModel(id: 14, name: "LocalNotificationVC", viewController: LocalNotificationVC()),
                ListModel(id: 15, name: "PagViewControllerWithButtonVC", viewController: PagViewControllerWithButtonVC()),
                ListModel(id: 16, name: "ViewController", viewController: PageViewController()),
                ListModel(id: 17, name: "LocalizableContoller", viewController: LocalizableContoller()),
                ListModel(id: 18, name: "SliderController", viewController: SliderController()),
                ListModel(id: 19, name: "SectionedTableViewController", viewController: DragDropTableViewCellContoler()),
                ListModel(id: 20, name: "SectionedTableViewController", viewController: ScannerController()),
                ListModel(id: 21, name: "PreventionScreen", viewController: PreventionScreen()),
                ListModel(id: 22, name: "GenerateQRCodeVC", viewController: GenerateQRCodeVC()),
            ]
        }
    }
}



extension DemoFeatureVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text =  "\(indexPath.row+1) - " + items[indexPath.item].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item =  items[indexPath.row]
        
        switch item.id{
        case 7:
            AlertMessage.shared.alertError()
        case 5,8,22:
            item.viewController!.modalPresentationStyle = .custom
            item.viewController!.transitioningDelegate = presentVC
            self.present(item.viewController!, animated: true)
        default:
            item.viewController?.leftBarButtonItem()
            self.navigationController?.pushViewController(item.viewController!, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView.isPagination(indexPath: indexPath,  arrayOfData: items.count, totalItems: totalList){
            tableView.showLoadingSpinner()
            currentPage += 1
            fetchDataAPI()
        }
    }
    
    func fetchDataAPI(){
        tableView.hideLoadingSpinner()
    }
}
