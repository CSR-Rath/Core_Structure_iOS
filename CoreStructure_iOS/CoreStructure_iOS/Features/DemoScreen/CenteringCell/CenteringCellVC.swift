//
//  CenteringCollectionViewCellVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 10/10/24.
//

import UIKit


class CenteringCellVC: BaseUIViewConroller {

    // Declared CollectionView variable:
    var collectionView : UICollectionView?

    // Variables asociated to collection view:
    fileprivate var currentPage: Int = 1
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }

    fileprivate var colors: [UIColor] = [UIColor.black, UIColor.red, UIColor.green, UIColor.yellow]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCollectionView()
        self.setupLayout()

    }

    private func setupLayout(){
        

        if let collection = collectionView{
            NSLayoutConstraint.activate([
                collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collection.leftAnchor.constraint(equalTo: view.leftAnchor),
                collection.rightAnchor.constraint(equalTo: view.rightAnchor),
                collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            ])
        }
    }


    private func addCollectionView(){

        // This is just an utility custom class to calculate screen points
        // to the screen based in a reference view. You can ignore this and write the points manually where is required.
        let pointEstimator = RelativeLayoutUtilityClass(referenceFrameSize: self.view.frame.size)

        // This is where the magic is done. With the flow layout the views are set to make costum movements.
        let layout = UPCarouselFlowLayout()
        // Set items size cell
        layout.itemSize = CGSize(width: pointEstimator.relativeWidth(multiplier: 0.8), height: 250)
        layout.scrollDirection = .horizontal

        // initialized with a layout object.
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // This line if for able programmatic constrains.
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(CardCell.self, forCellWithReuseIdentifier: "cellId")

        // Spacing between cells, show margin cell of items
        let spacingLayout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        spacingLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 20)
//        spacingLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 20)

        self.collectionView?.backgroundColor = UIColor.gray
        self.view.addSubview(self.collectionView!)

    }
}


// MARK: - Card Collection Delegate & DataSource
extension CenteringCellVC: UICollectionViewDelegate, UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CardCell

        cell.customView.backgroundColor = colors[indexPath.row]
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}
