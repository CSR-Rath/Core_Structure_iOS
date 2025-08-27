import UIKit

import UIKit

//class DragDropTableViewCellContoler: UIViewController,UITableViewDelegate {
//    
//    var tableView: UITableView!
//    var data = [
//        ["Item 0-0"], // Section 0
//        ["Item 1-0", "Item 1-1"], // Section 1
//        ["Item 2-0", "Item 2-1", "Item 2-2"] // Section 2
//    ]
//    
//    var isDragDropAction = false // State variable to track drag-and-drop
//    var isButtonClicked = false // Flag to track button clicks
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        setupButton()
//    }
//
//    func setupTableView() {
//        tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.dragDelegate = self
//        tableView.dropDelegate = self
//        tableView.dragInteractionEnabled = true
//        view.addSubview(tableView)
//    }
//
//    func setupButton() {
//        let button = UIButton(frame: CGRect(x: 20, y: 40, width: 100, height: 50))
//        button.setTitle("Action", for: .normal)
//        button.backgroundColor = .blue
//        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
//        view.addSubview(button)
//    }
//
//    @objc func buttonClicked() {
//        print("Button clicked")
//        isButtonClicked = true // Set the flag to indicate button was clicked
//        resetFlags() // Reset flags when button is clicked
//    }
//
//    private func resetFlags() {
//        isDragDropAction = false
//        isButtonClicked = false
//    }
//}
//
//// MARK: - UITableViewDataSource Methods
//extension DragDropTableViewCellContoler: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data[section].count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = data[indexPath.section][indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 300
//        } else {
//            return 50
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if !isDragDropAction {
//            print("Item selected: \(data[indexPath.section][indexPath.row])")
//        } else {
//            print("Selection ignored during drag-and-drop.")
//        }
//    }
//}
//
//// MARK: - UITableViewDragDelegate & UITableViewDropDelegate Methods
//extension DragDropTableViewCellContoler: UITableViewDragDelegate, UITableViewDropDelegate {
//
//    // Prevent dragging from section 0
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        print("itemsForBeginning")
//        
//        // Prevent dragging from section 0
//        if indexPath.section == 0 {
//            return [] // Return an empty array to cancel the drag
//        }
//        
//        isDragDropAction = true // Set the drag action flag
//        
//        let item = data[indexPath.section][indexPath.row]
//        let itemProvider = NSItemProvider(object: item as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//
//        return [dragItem]
//    }
//
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//        print("performDropWith called")
//        
//        guard !isButtonClicked else {
//            print("Drop canceled due to button click.")
//            resetFlags() // Reset flags
//            return
//        }
//
//        guard let destinationIndexPath = coordinator.destinationIndexPath else {
//            print("No destination index path.")
//            return
//        }
//        
//        
//
//        if let sourceIndexPath = coordinator.items.first?.sourceIndexPath {
//            guard destinationIndexPath.section > 0 else {
//                print("Invalid destination section.")
//                return
//            }
//
//            coordinator.session.loadObjects(ofClass: NSString.self) { items in
//                guard items is [String] else { return }
//
//                tableView.performBatchUpdates({
//                    let movedItem = self.data[sourceIndexPath.section].remove(at: sourceIndexPath.row)
//                    self.data[destinationIndexPath.section].insert(movedItem, at: destinationIndexPath.row)
//                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
//                }, completion: { _ in
//                    coordinator.drop(coordinator.items.first!.dragItem, toRowAt: destinationIndexPath)
//                })
//            }
//        } else {
//            print("No source index path.")
//        }
//    }
//
//    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
//        print("canHandle called")
//        return session.canLoadObjects(ofClass: NSString.self)
//    }
//
//    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//        print("dropSessionDidUpdate called")
//
//        guard destinationIndexPath != nil else {
//            return UITableViewDropProposal(operation: .cancel)
//        }
//
//        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//    }
//
//    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
//        print("dropSessionDidEnd called")
//        resetFlags() // Reset flags after the session ends
//    }
//
//    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        return nil
//    }
//}


import UIKit

class DragDropTableVC: BaseUIViewConroller {
    
    var tableView: UITableView!
    var data = [
        ["Item 0-0"], // Section 0
        ["Item 1-0", "Item 1-1"], // Section 1
        ["Item 2-0", "Item 2-1", "Item 2-2"] // Section 2
    ]
    
    var isDragDropAction = false // State variable to track drag-and-drop
    var isButtonClicked = false // Flag to track button clicks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupButton()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        view.addSubview(tableView)
    }

    func setupButton() {
        let button = UIButton(frame: CGRect(x: 20, y: 40, width: 100, height: 50))
        button.setTitle("Action", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func buttonClicked() {
        print("Button clicked")
        isButtonClicked = true // Set the flag to indicate button was clicked
        resetFlags() // Reset flags when button is clicked
    }

    private func resetFlags() {
        isDragDropAction = false
        isButtonClicked = false
    }
}

// MARK: - UITableViewDataSource Methods
extension DragDropTableVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300 // Custom height for section 0
        } else {
            return 50 // Default height for other sections
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Ignore selection for section 0 during drag-and-drop
        if !isDragDropAction {
            if indexPath.section != 0 {
                print("Item selected: \(data[indexPath.section][indexPath.row])")
            } else {
                print("Selection ignored in section 0 during drag-and-drop.")
            }
        } else {
            print("Selection ignored during drag-and-drop.")
        }
    }
}

// MARK: - UITableViewDragDelegate & UITableViewDropDelegate Methods
extension DragDropTableVC: UITableViewDragDelegate, UITableViewDropDelegate {

    // Prevent dragging from section 0
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("itemsForBeginning")
        
        // Prevent dragging from section 0
        if indexPath.section == 0 {
            print("Drag not allowed in section 0")
            return [] // Return an empty array to cancel the drag
        }
        
        isDragDropAction = true // Set the drag action flag
        
        let item = data[indexPath.section][indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item

        return [dragItem]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("performDropWith called")
        
        guard !isButtonClicked else {
            print("Drop canceled due to button click.")
            resetFlags() // Reset flags
            return
        }

        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            print("No destination index path.")
            return
        }

        if let sourceIndexPath = coordinator.items.first?.sourceIndexPath {
            guard destinationIndexPath.section != 0 else {
                print("Invalid destination section.")
                return
            }

            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                guard items is [String] else { return }

                tableView.performBatchUpdates({
                    let movedItem = self.data[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                    self.data[destinationIndexPath.section].insert(movedItem, at: destinationIndexPath.row)
                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                }, completion: { _ in
                    coordinator.drop(coordinator.items.first!.dragItem, toRowAt: destinationIndexPath)
                })
            }
        } else {
            print("No source index path.")
        }
    }

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        print("canHandle called")
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        print("dropSessionDidUpdate called")

        guard destinationIndexPath != nil else {
            return UITableViewDropProposal(operation: .cancel)
        }

        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        print("dropSessionDidEnd called")
        resetFlags() // Reset flags after the session ends
    }

    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return nil
    }
}
