//
//  BVM_VIP_View.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/11/24.
//

import UIKit


class BVM_VIP_Service_Cell : UICollectionViewCell{
    
    lazy var imgLogo: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.backgroundColor = .mainBlueColor
        return img
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "title Title"
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(imgLogo)
        addSubview(lblTitle)
        
        NSLayoutConstraint.activate([
        
            imgLogo.topAnchor.constraint(equalTo: topAnchor),
            imgLogo.heightAnchor.constraint(equalToConstant: 60),
            imgLogo.leftAnchor.constraint(equalTo: leftAnchor),
            imgLogo.rightAnchor.constraint(equalTo: rightAnchor),
            
            lblTitle.leftAnchor.constraint(equalTo: leftAnchor),
            lblTitle.rightAnchor.constraint(equalTo: rightAnchor),
            lblTitle.topAnchor.constraint(equalTo: imgLogo.bottomAnchor,constant: 5),
            
        ])
    }
    
}


class BVM_VIP_Cell: UITableViewCell {
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius  = 20
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightText
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 20

        collectionView.contentInset = UIEdgeInsets(top: 25, left: 15, bottom: 0, right: 0)
        collectionView.register(BVM_VIP_Service_Cell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 120) // Set a fixed height

        ])
    }
}

extension BVM_VIP_Cell: UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 // Ensure this number is greater than what can fit in the fixed height
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BVM_VIP_Service_Cell
//        cell.backgroundColor = .cyan
        return cell
    }
    
    
    // Set the size for each item in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 60 // Set the desired width of the cell
        let cellHeight: CGFloat = collectionView.frame.height // Set the desired height of the cell
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}



extension BVM_VIP_View: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BVM_VIP_Cell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        let label = UILabel()
        label.text = "Title "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: header.leftAnchor,constant: 20),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor,constant: -15),
        
        ])
        
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}

class BVM_VIP_View: UIView {
    
    
    lazy var itemLeftView: ItemView = {
        let view = ItemView()
        
        return view
    }()
    
    lazy var itemRightView: ItemView = {
        let view = ItemView()
        
        return view
    }()
    
    lazy var stackItems: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemLeftView, itemRightView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainBlueColor
        view.bounces = false
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
//        view.rowHeight = 120
        view.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        view.delegate = self
        view.dataSource = self
        view.register(BVM_VIP_Cell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        return view
    }()
    
    let line: LineView = {
        let line = LineView()
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(tableView)
        addSubview(stackItems)
        
        addSubview(line)
    
        NSLayoutConstraint.activate([
            
            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackItems.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
            stackItems.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            stackItems.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            
            line.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -30),
            line.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 30),
            line.rightAnchor.constraint(equalTo: tableView.rightAnchor, constant: -30),
            
            
            
            
        
        ])
    }
}


class ItemView : UIView{
    
    lazy var icon: UIImageView = {
        let img = UIImageView()
        img.image = .add
        return img
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "_"
        
        return lbl
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [icon,lblTitle])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.backgroundColor = .white
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBlueColor
        
        setupUI()
        self.layer.cornerRadius = 20
        self.heightAnchor.constraint(equalToConstant: 65).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),

//
//            stack.topAnchor.constraint(equalTo: topAnchor),
//            stack.leftAnchor.constraint(equalTo: leftAnchor),
//            stack.rightAnchor.constraint(equalTo: rightAnchor),
//            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
 
    }
    
}


class LineView : UIView{
    
    lazy var lineView_1: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var lineView_2: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var lineView_3: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var icon_1: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        return img
    }()
    
    lazy var icon_2: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        return img
    }()
    
    lazy var icon_3: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        return img
    }()
    
    lazy var icon_4: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        return img
    }()
    
    lazy var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lineView_1,lineView_2,lineView_3])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        
        addSubview(stack)
        addSubview(icon_1)
        addSubview(icon_2)
        addSubview(icon_3)
        addSubview(icon_4)
        
        
        NSLayoutConstraint.activate([
        
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),
            
            lineView_1.heightAnchor.constraint(equalToConstant: 5),
            lineView_2.heightAnchor.constraint(equalToConstant: 5),
            lineView_3.heightAnchor.constraint(equalToConstant: 5),
            
            
            icon_1.centerXAnchor.constraint(equalTo: lineView_1.leftAnchor),
            icon_1.centerYAnchor.constraint(equalTo: lineView_1.centerYAnchor),
            
            
            icon_2.centerXAnchor.constraint(equalTo: lineView_2.leftAnchor),
            icon_2.centerYAnchor.constraint(equalTo: lineView_2.centerYAnchor),
            
            icon_3.centerXAnchor.constraint(equalTo: lineView_3.leftAnchor),
            icon_3.centerYAnchor.constraint(equalTo: lineView_3.centerYAnchor),
        
            icon_4.centerXAnchor.constraint(equalTo: lineView_3.rightAnchor),
            icon_4.centerYAnchor.constraint(equalTo: lineView_3.centerYAnchor),
            
            
            icon_1.heightAnchor.constraint(equalToConstant: 20),
            icon_1.widthAnchor.constraint(equalToConstant: 20),
            
            icon_2.heightAnchor.constraint(equalToConstant: 20),
            icon_2.widthAnchor.constraint(equalToConstant: 20),
            
            icon_3.heightAnchor.constraint(equalToConstant: 20),
            icon_3.widthAnchor.constraint(equalToConstant: 20),
            
            icon_4.heightAnchor.constraint(equalToConstant: 20),
            icon_4.widthAnchor.constraint(equalToConstant: 20),
        ])
        
    }
}
