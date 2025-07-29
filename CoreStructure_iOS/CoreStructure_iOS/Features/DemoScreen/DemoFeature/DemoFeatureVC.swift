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

class DemoFeatureVC: BaseInteractionViewController {
    
    var tableView = UITableView()
    private var previousOffsetY: CGFloat = 0
    private var isScrollingDown : Bool = false
    var didScrollView: ((_ : UIScrollView)->())?
    
    var currentPage: Int = 0
    var totalList: Int = 0
    
    var items : [ListModel] = []{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                tableView.stopRefreshing()
                tableView.isHideLoadingSpinner()
                tableView.reloadData()
                
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default // Black text on white background
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        pullRefresh()
    }
    
    @objc func rightButtonTapped() {
        print("Right button tapped")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Demo"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupConstraint(){
        
        tableView =  UITableView()
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.addRefreshControl(target: self, action: #selector(pullRefresh))
        
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
        ])
        
        
        let button = BaseUIButton(frame: CGRect(x: 100,
                                                y: 0,
                                                width: 200,
                                                height: 300))
        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        
    }
    
    @objc private func pullRefresh(){
        
        
        items =   [
            
            
            ListModel(id: 26, name: "APITheSameTimeVC", viewController: APITheSameTimeVC()),
            ListModel(id: 26, name: "PageVC", viewController: PageVC()),
            ListModel(id: 25, name: "UploadImageVC", viewController: UploadImageVC()),
            ListModel(id: 24, name: "GenerteQRAndBarCodeVC", viewController: GenerteQRAndBarCodeVC()),
            ListModel(id: 23, name: "PaymentVC", viewController: PaymentVC()),
            ListModel(id: 22, name: "PhoneTextFieldVC", viewController: PhoneTextFieldVC()),
            ListModel(id: 21, name: "TestingButtonVC", viewController: TestingButtonVC()),
            ListModel(id: 20, name: "HomeABAVC", viewController: HomeABAVC()),
            ListModel(id: 19, name: "PreventionScreenVC", viewController: PreventionScreenVC()),
            ListModel(id: 18, name: "ScannerController", viewController: ScannerCV()),
            ListModel(id: 17, name: "SectionedTableViewController", viewController: DragDropTableVC()),
            ListModel(id: 16, name: "SliderController", viewController: SliderVC()),
            ListModel(id: 15, name: "LocalizableVC", viewController: LocalizableVC()),
            ListModel(id: 14, name: "PagViewControllerWithButtonVC", viewController: SegmentPageViewController()),
            ListModel(id: 13, name: "LocalNotificationVC", viewController: LocalNotificationVC()),
            ListModel(id: 12, name: "HandleNavigationBarVC", viewController: HandleNavigationBarVC()),
            ListModel(id: 11, name: "DragDropCollectionVC", viewController: DragDropCollectionVC()),
            ListModel(id: 10, name: "ExspandTableVC", viewController: ExspandTableVC()),
            ListModel(id: 9, name: "GroupDateVC", viewController: GroupDateVC()),
            ListModel(id: 8, name: "Cell Alert Error", viewController: nil),
            ListModel(id: 7, name: "CenteringCellVC", viewController: CenteringCellVC()),
            ListModel(id: 6, name: "BoardCollectionVC", viewController: BoardCollectionVC()),
            ListModel(id: 5, name: "OTPVC", viewController: OTPVC()),
            ListModel(id: 4, name: "PasscodeVC", viewController: PasscodeVC()),
            ListModel(id: 3, name: "CrashlyticsVC", viewController: CrashlyticsVC()),
            ListModel(id: 2, name: "DisplayBaseInteractionVC", viewController: DisplayBaseInteractionVC()),
            ListModel(id: 1, name: "LifecycleVC", viewController: LifecycleVC()),
            
        ]
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        didScrollView?(scrollView)
    }
    
}

extension DemoFeatureVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text =  "\(indexPath.row+1) - " + items[indexPath.item].name
        
        if isScrollingDown { // Only animate when scrolling down
            cell.animateScrollCell(index: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item =  items[indexPath.row].viewController ?? UIViewController()
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.pushVC(to: item)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView.isPagination(indexPath: indexPath,
                                  arrayCount: items.count,
                                  totalItems: 100){
            print("isPagination")
            currentPage += 1
        }
    }
    
    
    @objc func didTappedButton(){
        
        let pdfFilePath = tableView.exportAsPdfFromTable()
        let pdfURL = URL(fileURLWithPath: pdfFilePath)
        
        let activityViewController = UIActivityViewController(activityItems: [pdfURL],
                                                              applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
}


//import UIKit

//class RefreshManager {
//    
//    static func add(to scrollView: UIScrollView,
//                    tintColor: UIColor = .red,
//                    target: Any,
//                    action: Selector) {
//        if scrollView.refreshControl == nil {
//            let refreshControl = UIRefreshControl()
//            refreshControl.tintColor = tintColor
//            refreshControl.addTarget(target, action: action, for: .valueChanged)
//            scrollView.refreshControl = refreshControl
//        }
//    }
//    
//    static func endRefreshing(_ scrollView: UIScrollView) {
//        scrollView.refreshControl?.endRefreshing()
//    }
//}
