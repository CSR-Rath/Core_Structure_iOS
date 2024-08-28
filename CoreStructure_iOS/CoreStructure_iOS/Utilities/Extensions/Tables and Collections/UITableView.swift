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
