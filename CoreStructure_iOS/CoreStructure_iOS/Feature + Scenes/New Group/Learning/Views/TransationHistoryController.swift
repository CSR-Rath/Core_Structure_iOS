//
//  TransationHistoryController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 30/11/24.
//

import UIKit

class TransationHistoryController: UIViewController, UIGestureRecognizerDelegate {

    private var models: [Transaction] =  DatabaseManager().fetchTransaction(){
        didSet{
            totleAll = models.count
            groupEvents(models)
            tableView.reloadData()
        }
    }
    
    private var totleAll = 0
    private var groupedEvents: [String: [Transaction]] = [:]
    private var sectionDate: [String] = []
    {
        didSet{
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leftBarButton()
        self.setupTitleNavigationBar(titleColor: .white, backColor: .mainBlueColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Transaction History"
        //Enable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setupUI()
        groupEvents(DatabaseManager().fetchTransaction())
        
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.frame  = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        
        tableView.addRefreshControl(target: self,
                                    action: #selector(pullRefresh))
    }
    
    
    @objc private func pullRefresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
          models = DatabaseManager().fetchTransaction()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    
    private func groupEvents(_ events: [Transaction]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        groupedEvents = Dictionary(grouping: events) { (event) -> String in
            return dateFormatter.string(from: event.date)
        }
        
        sectionDate =  groupedEvents.keys.sorted(by: { $0 > $1 })// big to small
        //groupedEvents.keys.sorted() // small to big
        
        tableView.reloadData()
    }
}

extension TransationHistoryController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if sectionDate.count > 0 {
            tableView.restore()
        }else{
         
            tableView.setEmptyView()
           
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        
        let date = sectionDate[indexPath.section]
        let events = groupedEvents[date]
        let event = events?[indexPath.row]
        
        cell.imgLogo.isHidden = true
        
        cell.lblPrice.text = "Order items"
        cell.lblName.text = "Payment by " + (event?.paymentType ?? "")
        cell.lblDate.text = formatDateToCustomString(date: event?.date ?? Date()) // event?.date.timeAgoDisplay()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor =  .mainBlueColor
        
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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let date = sectionDate[indexPath.section]
        let events = groupedEvents[date]
        let event = events?[indexPath.row]
        
        let vc = TransationDeatilController()
        vc.dataList = event ?? Transaction()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func formatDateToCustomString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy - HH:mm"
        return dateFormatter.string(from: date)
    }
    
}


class TransactionCell: UITableViewCell{
    
    var didTappedButton: (()->())?
    
    var didTappedDelete: (()->())?
    var didTappedEdit: (()->())?
    
    let lblPrice = UILabel()
    let lblName =  UILabel()
    let lblDate =  UILabel()
    let imgLogo = UIImageView()

    
    var decrementAndIncrement: Int = 1 {
        didSet{
            
        }
    }
    

    var isFromProductCell : IsFromProductCell = .productList {
        didSet{
           
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TransactionCell{
    
    @objc  func decrementValue(_ sender: UIButton){
        
        if decrementAndIncrement > 1{
            decrementAndIncrement -= 1
            didTappedButton?()
        }
    }
    
    @objc func incrementValue(_ sender: UIButton){
        
        decrementAndIncrement += 1
        didTappedButton?()
    }
    
    

    private func setupUI(){
        
      
        addSubview(imgLogo)
        addSubview(lblPrice)
        addSubview(lblName)
        addSubview(lblDate)
        
        imgLogo.translatesAutoresizingMaskIntoConstraints = false
        lblPrice.translatesAutoresizingMaskIntoConstraints = false
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblDate.translatesAutoresizingMaskIntoConstraints = false

        
        imgLogo.backgroundColor = .lightGray
        imgLogo.layer.cornerRadius = 80/2
        imgLogo.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([

            
            lblPrice.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            lblPrice.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
            
            lblName.topAnchor.constraint(equalTo: lblPrice.bottomAnchor,constant: 10),
            lblName.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
            
            lblDate.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            lblDate.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
        ])
        
    }
}
