import UIKit


//MARK: Multiple dropdown session
class ExpandedMultipleSectionVC: UIViewController {
    
    //MARK: Mutiple section expended
    var expandedSectionIndices: [Int] = [] // Array to store expanded section indices
    
    //MARK: Single section expended
    var expandedSectionIndex: Int?
    
    let tableView = UITableView()
    
    var data = [
        ("Section 0", ["Item 1", "Item 2", "Item 3"]),
        ("Section 1", ["Item 4", "Item 5"]),
        ("Section 2", ["Item 6", "Item 7", "Item 8", "Item 9"]),
        ("Section 3", ["Item 6", "Item 7", "Item 8", "Item 9"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Expand Multiple Section"
        view.backgroundColor = .orange
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "ExpandableTableViewCell")
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ExpandedMultipleSectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //MARK: Mutiple section expended
        if  expandedSectionIndices.contains(section) {
            return data[section].1.count
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableTableViewCell", for: indexPath) as! ExpandableTableViewCell
        
        cell.textLabel?.text = data[indexPath.section].1[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = .cyan
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .orange
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.text = data[section].0
        
        let arrowImageView = UIImageView()
        arrowImageView.tintColor = .gray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(arrowImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        //MARK: Mutiple section expended
        if expandedSectionIndices.contains(section) {
            arrowImageView.image = UIImage(systemName: "chevron.up")
        } else {
            arrowImageView.image = UIImage(systemName: "chevron.down")
        }
        
        
        //MARK: Single section expended
//        if expandedSectionIndex == section {
//            arrowImageView.image = UIImage(systemName: "chevron.up")
//        }else{
//            arrowImageView.image = UIImage(systemName: "chevron.down")
//        }
        
        
        return headerView
    }
    
    //MARK: Multiple section expended
        @objc func didTapHeader(_ sender: UITapGestureRecognizer) {
            guard let section = sender.view?.tag else { return }

            if let index = expandedSectionIndices.firstIndex(of: section) {
                expandedSectionIndices.remove(at: index)
            } else {
                expandedSectionIndices.append(section)
            }

            tableView.reloadData()
        }
    

}


