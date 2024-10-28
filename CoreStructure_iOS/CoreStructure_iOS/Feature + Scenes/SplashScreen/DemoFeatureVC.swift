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
        ListModel(id: 5, name: "DemoBottomSheetViewController", viewController: DemoBottomSheetViewController()),
        ListModel(id: 6, name: "CenteringCollectionViewCellVC", viewController: CenteringCellVC()),
        ListModel(id: 7, name: "Cell Alert Error", viewController: nil),
        ListModel(id: 8, name: "PanGestureVC", viewController: PanGestureVC()),
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
                                     cellHeight: nil,
                                     sections: [items])
        
        tableView.dataSource = dataTable
        tableView.delegate = dataTable
        tableView.addRefreshControl(target: self, action: #selector(refreshControl))
        
        
        
        dataTable.configureCell = { [self] cell, item, indexPath in
            
            cell.titleLabel.text = items[indexPath.item].id.description + " - " + items[indexPath.item].name
            
        }
        
        dataTable.didDelectCell = { item, indexPath in
            print("item ==>",item)
            
            if let item = item as? ListModel{
//                print("Selected item: \(item.name)")
//                let vc = item.viewController as! TableHandlerVC
//                vc.handleTableView.updateItems(inSection: 0, newItems: ["a","b"])
                
                if item.id == 7  {
                    AlertMessage.shared.alertError()
                }else if item.id == 8{
                    
                    let vc = item.viewController
                    vc?.modalPresentationStyle = .custom
                    vc?.transitioningDelegate = presentVC
                    
                    self.present(vc!, animated: true)
                    
                }else{
                        
                    self.navigationController?.pushViewController(item.viewController!, animated: true)
                }

            }
            
           
            
        }
        
        dataTable.selectedCell = { item in
//            print("Selected item: \(item)")
            
            if let item = item as? ListModel{
                print("Selected item: \(item.name)")
            }
            
            
            
        }
        
    }
    
    
    @objc private func refreshControl(){
        
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
