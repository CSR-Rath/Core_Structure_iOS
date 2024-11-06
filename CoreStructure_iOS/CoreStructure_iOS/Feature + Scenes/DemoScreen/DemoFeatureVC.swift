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
    
    private var dataTable : TableViewHandler<CustomTableViewCell, Any>!
    
    
    let items : [ListModel] = [
        ListModel(id: 1, name: "TableHandlerVC", viewController: TableHandlerVC()),
        ListModel(id: 2, name: "PasscodeVC", viewController: PasscodeVC()),
        ListModel(id: 3, name: "OTPVC", viewController: OTPVC()),
        ListModel(id: 4, name: "BoardCollectionVC", viewController: BoardCollectionVC()),
        ListModel(id: 5, name: "PanGestureTwoVC", viewController: PanGestureTwoVC()),
        ListModel(id: 6, name: "CenteringCollectionViewCellVC", viewController: CenteringCellVC()),
        ListModel(id: 7, name: "Cell Alert Error", viewController: nil),
        ListModel(id: 8, name: "PanGestureVC", viewController: PanGestureVC()),
        ListModel(id: 9, name: "GroupDateVC", viewController: GroupDateVC()),
        ListModel(id: 10, name: "ExspandTableVC", viewController: ExspandTableVC()),
        ListModel(id: 11, name: "DragDropCollectionVC", viewController: DragDropCollectionVC()),
        ListModel(id: 12, name: "ButtonOntheKeyboradVC", viewController: ButtonOntheKeyboradVC()),
        ListModel(id: 13, name: "HandleNavigationBarVC", viewController: HandleNavigationBarVC()),
        ListModel(id: 14, name: "LocalNotificationVC", viewController: LocalNotificationVC()),
        ListModel(id: 15, name: "PagViewControllerWithButtonVC", viewController: PagViewControllerWithButtonVC()),
        ListModel(id: 16, name: "ViewController", viewController: PageViewController()),
        
        
        
        
        
        
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()

    }
    
    private func setupConstraint(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.backgroundColor = .lightText
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        dataTable = TableViewHandler(cellIdentifier: "cell",
                                     cellHeight: 70,
                                     sections: [items])
        
        tableView.backgroundColor = .white
        tableView.dataSource = dataTable
        tableView.delegate = dataTable
        tableView.addRefreshControl(target: self, action: #selector(pullRefresh))
        
        
        
        dataTable.configureCell = { [self] cell, item, indexPath in
            
            cell.titleLabel.text = items[indexPath.item].id.description + " - " + items[indexPath.item].name
            
        }
        
        dataTable.headerHeightForSection = { section in
            return 0
        }
        dataTable.didDelectCell = { item, indexPath in
            print("item ==>",item)
            
            if let item = item as? ListModel{
                if item.id == 7  {
                    AlertMessage.shared.alertError()
                }else if item.id == 8 ||  item.id == 5 {
                    
                    let vc = item.viewController
                    vc?.modalPresentationStyle = .custom
                    vc?.transitioningDelegate = presentVC
                    
                    self.present(vc!, animated: true)
                    
                }else{
 
                    item.viewController?.leftBarButton()
                    self.navigationController?.pushViewController(item.viewController!, animated: true)
                }
            }
        }
        
        
        dataTable.configureHeader = { viewH, item, indexPath in 
            
            
        }
        
        
        dataTable.selectedCell = { item in

            if let item = item as? ListModel{
                print("Selected item: \(item.name)")
            }
            
        }
    }
    
    @objc private func pullRefresh(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            
            tableView.refreshControl?.endRefreshing()
            
        }
    }
    
}

class SecondViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
}


class ThreeViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = UIViewController()
        vc.title = "Testing"
        vc.view.backgroundColor = .green
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
}

class FourViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
