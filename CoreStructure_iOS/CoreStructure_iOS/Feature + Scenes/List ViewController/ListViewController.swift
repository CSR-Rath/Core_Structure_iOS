//
//  ListViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit

class ListViewController: UIViewController {
  private var tableView : UITableView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        //MARK: Refresh table view
//        tableView.setupRefreshControl()
//        UITableView.actionRefresh = { [self] in
//            print("Testing")
//            tableView.endRefreshData()
//        }
//        
    }
}

extension  ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let vc = VisitCommercialVC()
//        vc.modalPresentationStyle = .overCurrentContext
//
//        self.present(vc, animated: false) 
//        
        
//        let vc =  DemoBottomSheetViewController()
////        vc.transitioningDelegate = presentationStyle
////        vc.modalPresentationStyle = .custom
////        self.present(vc, animated: true) {
////            
////        }
        ///
        ///
        ///
        
        AlertMessage.shared.alertError()
////
//        let vc = DemoBottomSheetViewController()
//        presentBottomSheet(viewController: vc)
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: false) {
//            
//        }
//        presentBottomSheet(viewController: vc)
        
    }
}
