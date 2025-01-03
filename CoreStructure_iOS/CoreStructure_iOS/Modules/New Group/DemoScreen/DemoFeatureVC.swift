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
//"goodbye_message".localizeString()

class DemoFeatureVC: UIViewController {
    
    private var tableView: UITableView! = nil
    
    
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
        ListModel(id: 17, name: "LocalizableContoller", viewController: LocalizableContoller()),
        ListModel(id: 18, name: "SliderController", viewController: SliderController()),
        ListModel(id: 19, name: "SectionedTableViewController", viewController: DragDropTableViewCellContoler()),
        ListModel(id: 20, name: "SectionedTableViewController", viewController: ScannerController()),
        ListModel(id: 21, name: "PreventionScreen", viewController: PreventionScreen()),
        
    ]

    
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
        } else {
            // Fallback on earlier versions
        }
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.addRefreshControl(target: self, action: #selector(pullRefresh))
        
    }
    
    @objc private func pullRefresh(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            
            tableView.refreshControl?.endRefreshing()
            
        }
    }
    
}



extension DemoFeatureVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text = items[indexPath.item].id.description + " - " + items[indexPath.item].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item =  items[indexPath.row]
        
        
        if item.id == 7  {
            AlertMessage.shared.alertError()
        }else if item.id == 8 ||  item.id == 5 {
            
            let vc = item.viewController
            vc?.modalPresentationStyle = .custom
            vc?.transitioningDelegate = presentVC
            
            self.present(vc!, animated: true)
            
        }else{
            
            item.viewController?.leftBackButton()
            self.navigationController?.pushViewController(item.viewController!, animated: true)
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
