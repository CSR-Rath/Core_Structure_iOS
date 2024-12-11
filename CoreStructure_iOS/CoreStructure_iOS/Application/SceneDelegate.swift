//
//  SceneDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit




class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let loginSuccesFull = UserDefaults.standard.bool(forKey: KeyUser.loginSuccesFull)

        //MARK: - Check loginSuccesFull 
        let controller: UIViewController =  HomeViewController()//ReservationViewController() // GeustController() //HomeViewController() //loginSuccesFull ? SplashScreenController() : WelcomeContoller()
        
        let navigation = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}


extension SceneDelegate{
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
    }

}




import UIKit

//class MyViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
//    
//    private let collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    private let collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    
//    private var items1: [String] = ["Item 1", "Item 2", "Item 3"]
//    private var items2: [String] = ["Item A", "Item B", "Item C"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupCollectionViews()
//        
//        collectionView1.dragDelegate = self
//        collectionView1.dropDelegate = self
//        collectionView2.dragDelegate = self
//        collectionView2.dropDelegate = self
//        
//        collectionView1.dragInteractionEnabled = true
//        collectionView2.dragInteractionEnabled = true
//        collectionView1.dropInteractionEnabled = true
//        collectionView2.dropInteractionEnabled = true
//    }
//    
//    private func setupCollectionViews() {
//        view.addSubview(collectionView1)
//        view.addSubview(collectionView2)
//        
//        collectionView1.translatesAutoresizingMaskIntoConstraints = false
//        collectionView2.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            collectionView1.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView1.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
//            collectionView1.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            collectionView2.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView2.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
//            collectionView2.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        collectionView1.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
//        collectionView2.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
//        
//        collectionView1.dataSource = self
//        collectionView1.delegate = self
//        collectionView2.dataSource = self
//        collectionView2.delegate = self
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return collectionView == collectionView1 ? items1.count : items2.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView == collectionView1 ? "cell1" : "cell2", for: indexPath)
//        
//        let item = collectionView == collectionView1 ? items1[indexPath.item] : items2[indexPath.item]
//        cell.textLabel?.text = item
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width / 2 - 20, height: 50)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = collectionView == collectionView1 ? items1[indexPath.item] : items2[indexPath.item]
//        let itemProvider = NSItemProvider(object: item as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        return [dragItem]
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//        if collectionView == collectionView1 {
//            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//        } else {
//            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        if collectionView == collectionView1 {
//            // Handle drop in collectionView1
//            guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
//            
//            coordinator.drop(coordinator.items1, toItemAt: [destinationIndexPath])
//            
//            // Update the data source
//            var movedItem: String?
//            if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
//                movedItem = items1.remove(at: sourceIndexPath.item)
//                items1.insert(movedItem!, at: destinationIndexPath.item)
//            }
//            
//            collectionView1.reloadData()
//        } else {
//            // Handle drop in collectionView2
//            guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
//            
//            coordinator.drop(coordinator.items2, toItemAt: [destinationIndexPath])
//            
//            // Update the data source
//            var copiedItem: String?
//            if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
//                copiedItem = collectionView == collectionView1 ? items1[sourceIndexPath.item] : items2[sourceIndexPath.item]
//                items2.insert(copiedItem!, at: destinationIndexPath.item)
//            }
//            
//            collectionView2.reloadData()
//        }
//    }
//}
