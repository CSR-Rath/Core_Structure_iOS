//
//  PagViewControllerWithButtonVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/11/24.
//

import UIKit

class SegmentPageViewController: BaseUIViewConroller {
    
    let pageview = BaseUIPageViewController()
    let segmentedView = SegmentedView()
    
    var isFromButton: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "PagviewController"
        //Enable back swipe gesture

        setupConstraint()
        
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .lightGray
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .gray
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .lightGray
        
        let allVC = [vc1,vc2,vc3]
        let allTitle = ["A", "B", "C"]
        

        setupPagviewAndButton(page: pageview,
                              segment: segmentedView,
                              controllers: allVC,
                              titleButtons: allTitle,
                              indexSelected: 0)
       

//        segmentedView.didSectedBuuton = { [self] index in
//            
//            print("didSectedBuuton", index)
////            pageview.  = index
//            
//        }
        
//        pageview.didChangeIndex = { [self] index in
//         
//            print("didChangeIndex", index)
////            segmentedView.selectedIndex = index
//            
//        }
        
    }
    
    
    private func setupPagviewAndButton(page: BaseUIPageViewController,
                                       segment: SegmentedView,
                                       controllers: [UIViewController],
                                       titleButtons: [String],
                                       indexSelected: Int){
        
//        page.controllers = controllers
//        segment.items = titleButtons
//        
//        if controllers.count > 0 && titleButtons.count > 0{
//            page.currentPage = indexSelected
//            segment.selectedIndex = indexSelected
//        }

    }
    
    
    private func setupConstraint(){
        view.addSubview(pageview.view)
       
        pageview.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segmentedView)
        segmentedView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            
            segmentedView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 20),
            segmentedView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20),
            segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedView.heightAnchor.constraint(equalToConstant: 50),
            
            pageview.view.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 0),
            pageview.view.rightAnchor.constraint(equalTo: view.rightAnchor,constant: 0),
            pageview.view.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
            pageview.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
}
