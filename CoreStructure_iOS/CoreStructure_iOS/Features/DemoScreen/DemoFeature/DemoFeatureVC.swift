//
//  DemoFeatureVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit
import 

struct ListModel {
    let id: Int
    let name: String
    let createViewController: () -> UIViewController
}

class DemoFeatureVC: BaseUIViewConroller {

    var tableView = UITableView()
    private var previousOffsetY: CGFloat = 0
    private var isScrollingDown : Bool = false
    var didScrollView: ((_ : UIScrollView)->())?

    var currentPage: Int = 0
    var totalList: Int = 0

    var items : [ListModel] =  [
        ListModel(id: 26, name: "APITheSameTimeVC", createViewController: { APITheSameTimeVC() }),
        ListModel(id: 25, name: "PageVC", createViewController: { PageVC() }),
        ListModel(id: 24, name: "UploadImageVC", createViewController: { UploadImageVC() }),
        ListModel(id: 23, name: "GenerteQRAndBarCodeVC", createViewController: { GenerteQRAndBarCodeVC() }),
        ListModel(id: 22, name: "PaymentVC", createViewController: { PaymentVC() }),
        ListModel(id: 21, name: "PhoneTextFieldVC", createViewController: { PhoneTextFieldVC() }),
        ListModel(id: 20, name: "TestingButtonVC", createViewController: { TestingButtonVC() }),
        ListModel(id: 19, name: "HomeABAVC", createViewController: { HomeABAVC() }),
        ListModel(id: 18, name: "PreventionScreenVC", createViewController: { PreventionScreenVC() }),
        ListModel(id: 17, name: "ScannerController", createViewController: { ScannerCV() }),
        ListModel(id: 16, name: "SectionedTableViewController", createViewController: { DragDropTableVC() }),
        ListModel(id: 15, name: "SliderController", createViewController: { SliderVC() }),
        ListModel(id: 14, name: "LocalizableVC", createViewController: { LocalizableVC() }),
        ListModel(id: 13, name: "PagViewControllerWithButtonVC", createViewController: { SegmentPageViewController() }),
        ListModel(id: 12, name: "LocalNotificationVC", createViewController: { LocalNotificationVC() }),
        ListModel(id: 11, name: "HandleNavigationBarVC", createViewController: { HandleNavigationBarVC() }),
        ListModel(id: 10, name: "DragDropCollectionVC", createViewController: { DragDropCollectionVC() }),
        ListModel(id: 9, name: "ExspandTableVC", createViewController: { ExspandTableVC() }),
        ListModel(id: 8, name: "GroupDateVC", createViewController: { GroupDateVC() }),
        ListModel(id: 7, name: "Cell Alert Error", createViewController: { UIViewController() }),
        ListModel(id: 6, name: "CenteringCellVC", createViewController: { CenteringCellVC() }),
        ListModel(id: 5, name: "BoardCollectionVC", createViewController: { BoardCollectionVC() }),
        ListModel(id: 4, name: "OTPVC", createViewController: { OTPVC() }),
        ListModel(id: 3, name: "PasscodeVC", createViewController: { PasscodeVC() }),
        ListModel(id: 2, name: "CrashlyticsVC", createViewController: { CrashlyticsVC() }),
        ListModel(id: 0, name: "LifecycleVC", createViewController: { LifecycleVC() }),
    ] 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        pullRefresh()
    }

    private func setupConstraint(){
        tableView = UITableView()
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
    }

    @objc private func pullRefresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            tableView.stopRefreshing()
            tableView.isHideLoadingSpinner()
            tableView.reloadData()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollView?(scrollView)
    }
}

extension DemoFeatureVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text = "\(indexPath.row + 1) - \(items[indexPath.row].name)"

        if isScrollingDown {
            cell.animateScrollCell(index: indexPath.row)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = items[indexPath.row].createViewController()
        self.pushVC(to: viewController)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if tableView.isPagination(indexPath: indexPath, arrayCount: items.count, totalItems: 100) {
//            print("isPagination")
//            currentPage += 1
//        }
    }
}
