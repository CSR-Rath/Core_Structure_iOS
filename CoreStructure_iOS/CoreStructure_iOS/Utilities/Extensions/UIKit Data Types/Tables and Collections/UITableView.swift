//
//  UITableView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import Foundation
import UIKit


//MARK: For table empty
extension UITableView {
    
    func setEmptyView(title: String = "Data Not Found ", messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x,
                                             y: self.center.y,
                                             width: self.bounds.size.width,
                                             height: self.bounds.size.height))
        
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        
        NSLayoutConstraint.activate([
            messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50),
            messageImageView.widthAnchor.constraint(equalToConstant: 100),
            messageImageView.heightAnchor.constraint(equalToConstant: 100),
            //----
            titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            
        ])
        
        
        messageImageView.contentMode = .scaleAspectFill
        //        messageImageView.image = .imgEmpty
        titleLabel.text = title
        titleLabel.fontBold(14)
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle =  .none  //.singleLine
    }
}


//MARK: For refreshController
extension UITableView{
    
    static let refresh = UIRefreshControl()
    static var actionRefresh: (()->())?
    
    func setupRefreshControl() {
        UITableView.refresh.tintColor = .blue
        UITableView.refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl = UITableView.refresh
    }
    
    
    @objc private func refreshData(){
        UITableView.actionRefresh?()
    }
    
    func endRefreshData(){
        UITableView.refresh.endRefreshing()
    }
    
}



//func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    let last = tableView.numberOfRows(inSection: 0)-1
//    let items =  result.count
//    if last == indexPath.row && allTotal > items{
//        page += 1
//        tableView.showLoadingSpinner(with: "Fetch data...")
//        getDataApi(page: page, size: size, isLoading: false)
//    }
//}

//MARK: Pagination fetch data
extension UITableView{
    
     func showLoadingSpinner(with title: String = "Fetch data.") {
        // Add a loading spinner and title to the table view
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()

        let titleLabel = UILabel()
        titleLabel.text = title
         titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = .red
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [spinner, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8

        let containerView = UIView(frame: CGRect(x: 0, y: 0,
                                                 width: self.bounds.width,
                                                 height: titleLabel.frame.height + spinner.frame.height + 16))
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
         
         
         self.tableFooterView = containerView
    }
    
     func hideLoadingSpinner() {
        // Remove the loading spinner from the table view
        self.tableFooterView = nil
    }
}
