//
//  SharedLinkViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/3/25.
//

import UIKit

class SharedLinkVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @objc func tapShareLink(_ sender: UIButton) {
        
        let descriptionTitle =
            """
            Click below link to open youtube: \("https://www.youtube.com/") from App Store or Play Store.
            """
        let sharedContents = [
            descriptionTitle
        ]
        
        let activityViewController = UIActivityViewController(activityItems: sharedContents,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }

}
