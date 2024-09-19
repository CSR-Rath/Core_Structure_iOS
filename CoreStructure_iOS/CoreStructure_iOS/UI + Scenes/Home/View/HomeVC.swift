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

class HomeVC: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeRefreshData()
    
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getData()
    }
    
    private func makeRefreshData(){
        //MARK: Handle Refresh data when didchange base only one function
        switch isRefreshFuncion{
            
        case .isWallet:
            isRefreshFuncion = .isNone
            
            getWallet(){
                
            }
            
        case .isUserInfor:
            isRefreshFuncion = .isNone
            
            gerUserInfor()
            
            
        case .isRefreshData:
            
            isRefreshFuncion = .isNone
            
        case .isNone:
            
            isRefreshFuncion = .isNone
            break
        }
    }
    
    
    private func getData(){
        
        getWallet {
            self.gerUserInfor()
        }
    }
    
    private func getWallet(success: @escaping () -> Void){
        
        HomeVM.getWalet { response in
            success()
            
        }
        
    }
    
    private func gerUserInfor(){
        
        HomeVM.getUserInfor(success: { response in
            
        })
    }
    
}
