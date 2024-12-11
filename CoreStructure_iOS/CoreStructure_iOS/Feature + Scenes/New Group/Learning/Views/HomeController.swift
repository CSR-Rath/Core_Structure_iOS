//
//  HomeController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/11/24.
//

import UIKit
import RealmSwift

class HomeController: UIViewController {
    
    let dataList :  [TitleValueModel] = [
        TitleValueModel(title: "1", value: "1"),
    ]
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTitleNavigationBar(titleColor: .white, backColor: .mainBlueColor)
        
        do {
            let realm = try Realm()
            print("Realm file path: \(realm.configuration.fileURL?.path ?? "Unable to get file path")")
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    
    private func setupUI(){
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
    }

}


extension HomeController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.backgroundColor = .clear
        
        cell.didSelectItemsCell = { [self] index in
            
            if index == 0{

                let vc = TransationHistoryController()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if index == 1{
                
                let vc = ProductController()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if index == 2 {
                
                if  UserDefaults.standard.string(forKey: KeyUser.userType) == UserTypeEnum.merchant.rawValue{
                    let vc = RegisterController()
                    let userStore = DatabaseManager().fetchUserSore()
                    if userStore.count > 0{
                        vc.userInfor = userStore.first ?? Store()
                        vc.lblTitle.text = "Store Infor"
                    }else{
                        vc.lblTitle.text = "Register Store"
                    }
                    vc.isRegister =  .profile
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    logou()
                }
            }else{
                logou()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.row == 0{
            return  UITableView.automaticDimension
        }else{
            return  300
        }
    }

    @objc func test(){
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
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
