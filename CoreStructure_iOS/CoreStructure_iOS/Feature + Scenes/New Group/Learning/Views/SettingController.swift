//
//  SettingController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/11/24.
//

import UIKit

class SettingController: UIViewController {

    var dataList : [String] = [
        "Profile",
        "Logout",
    ]
    
    let tableView = UITableView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Setting"
        leftBarButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.frame = view.bounds
        tableView.register(TransationDeatilCell.self, forCellReuseIdentifier: "TransationDeatilCell")
        view.addSubview(tableView)
    }
    
}


extension SettingController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransationDeatilCell", for: indexPath) as! TransationDeatilCell
        cell.lblName.text = dataList[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
//            
//            let vc = RegisterController()
//            vc.userInfor = DatabaseManager().fetch().first ?? User()
//            vc.isRegister = .profile
//            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1:

            logou()
            
        default:
            logou()
            
            break

        }
    }
    
    func logou() {
       // Create the alert controller
       let alertController = UIAlertController(title: "Logout",
                                               message: "Are you sure you want to logou.",
                                               preferredStyle: .alert)
       
       // Add the "Cancel" button
       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
           // Handle the cancel action
           print("Cancel tapped")
           self.dismiss(animated: true)
       }
       alertController.addAction(cancelAction)
       
       // Add the "OK" button
       let okAction = UIAlertAction(title: "OK", style: .default) { action in
           // Handle the OK action
           print("OK tapped")
    
           pushNoback(newVC: WelcomeContoller())
       }
       
       alertController.addAction(okAction)
       
       // Present the alert
       present(alertController, animated: true, completion: nil)
   }

    
}


