//
//  Notification + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 9/11/24.
//

import Foundation
import UIKit

extension Notification.Name {
    static let dragDropStateChanged = Notification.Name("dragDropStateChanged")
    static let didUpdateData = Notification.Name("didUpdateData")
}



class Test : UIViewController{
    
    func testing(){
       
        // Observe the notification
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidUpdate), name: .didUpdateData, object: nil)
        
        // Post a notification when data is updated
        NotificationCenter.default.post(name: .didUpdateData, object: nil, userInfo: ["newData": "Updated Data"])
        

    }
    
    
    @objc func dataDidUpdate(){
        print("dataDidUpdate")
    }
}


