//
//  GroupDateVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import UIKit

struct TansationDate: Codable {
    var type: String?
    var created: Int?
    var desc: String?
}



class GroupDateVC: BaseUIViewConroller {
    
    private var models: [TansationDate] = [
        TansationDate(type: "Deposit", created: 1724424400, desc: "Salary deposit"),
        TansationDate(type: "Withdrawal", created: 1724510000, desc: "Rent payment"),
        TansationDate(type: "Transfer", created: 1024590200, desc: "Payment to friend"),
        TansationDate(type: "Deposit", created: 1724683600, desc: "Freelance payment"),
        TansationDate(type: "Withdrawal", created: 1604770000, desc: "Cash withdrawal"),
        TansationDate(type: "Deposit", created: 1024816400, desc: "Bonus payment"),
        TansationDate(type: "Withdrawal", created: 1624942800, desc: "Grocery purchase"),
        TansationDate(type: "Transfer", created: 1695009200, desc: "Payment to utility provider"),
        TansationDate(type: "Deposit", created: 1605115600, desc: "Freelance payment"),
        TansationDate(type: "Withdrawal", created: 1625202000, desc: "Cash withdrawal"),
        TansationDate(type: "Deposit", created: 1625280400, desc: "Salary deposit"),
        TansationDate(type: "Withdrawal", created: 1625374800, desc: "Rent payment"),
        TansationDate(type: "Transfer", created: 1825461200, desc: "Payment to friend"),
        TansationDate(type: "Deposit", created: 1825547600, desc: "Freelance payment"),
        TansationDate(type: "Withdrawal", created: 1605634000, desc: "Cash withdrawal"),
        TansationDate(type: "Deposit", created: 1695720400, desc: "Bonus payment"),
        TansationDate(type: "Withdrawal", created: 1625806800, desc: "Grocery purchase"),
        TansationDate(type: "Transfer", created: 1625893200, desc: "Payment to utility provider"),
        TansationDate(type: "Deposit", created: 1605909600, desc: "Freelance payment"),
        TansationDate(type: "Withdrawal", created: 1620066000, desc: "Cash withdrawal")
    ]
    private var totleAll = 0
    private var groupedEvents: [String: [TansationDate]] = [:]
    private var sectionDate: [String] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightGray
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group Date"

        setupUI()
        groupEvents(models)
        totleAll = models.count
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.frame  = igorneSafeAeaTop
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    private func groupEvents(_ events: [TansationDate]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        groupedEvents = Dictionary(grouping: events) { (event) -> String in
            
            // Example integer timestamp
            let timestamp: Int = event.created!
            
            // Convert the integer timestamp to a Date
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
            
            return dateFormatter.string(from: date)
        }
        
        sectionDate =  groupedEvents.keys.sorted(by: { $0 > $1 })// big to small
        //groupedEvents.keys.sorted() // small to big
        
        tableView.reloadData()
    }
}

extension GroupDateVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = sectionDate[section]
        guard let events = groupedEvents[date] else {
            return 0
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let date = sectionDate[indexPath.section]
        let events = groupedEvents[date]
        let event = events?[indexPath.row]
        
        cell.textLabel?.text = event?.desc
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor =  .red
        
        let title = UILabel()
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = sectionDate[section]
        header.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor),
        ])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSection = tableView.numberOfSections-1
        let last = tableView.numberOfRows(inSection: lastSection) - 1
        
        if indexPath.section == lastSection{
            if indexPath.row == last &&  models.count < totleAll {
                // Cell api add new page
            }
        }
    }
}


import UIKit
import Combine

class UserMVVMCombineViewController: UIViewController {

    private let nameLabel = UILabel()
    private let showButton = UIButton(type: .system)

    private let viewModel = UserViewModel()
    private var cancellables = Set<AnyCancellable>()  // 🛑 រក្សា subscription

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        nameLabel.frame = CGRect(x: 40, y: 100, width: 300, height: 30)
        showButton.frame = CGRect(x: 40, y: 150, width: 120, height: 44)
        showButton.setTitle("បង្ហាញអ្នកប្រើ", for: .normal)
        showButton.addTarget(self, action: #selector(showUser), for: .touchUpInside)

        view.addSubview(nameLabel)
        view.addSubview(showButton)

        bindViewModel()
    }

    private func bindViewModel() {
        // ✅ Binding displayText ទៅ UI ដោយប្រើ Combine
        viewModel.$displayText
            .receive(on: DispatchQueue.main) // UI ត្រូវ update នៅលើ main thread
            .sink { [weak self] text in
                self?.nameLabel.text = text
            }
            .store(in: &cancellables)
    }

    @objc private func showUser() {
        viewModel.loadUser()
    }
}

import Combine

class UserViewModel {
    // ✅ @Published ប្រាប់ Combine ថា បើមានការផ្លាស់ប្តូរ -> បង្ហាញ UI ទៅវិញ
    @Published var displayText: String = ""

    func loadUser() {
        let user = Customer(name: "A", age: "50")
        displayText = "Name: \(user.name), Age: \(user.age)"
    }
}

struct Customer{
    var name: String
    var age: String
}
