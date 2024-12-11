import UIKit

class DragDropTableViewCellContoler: UIViewController {

    var tableView: UITableView!
    var data = [
        ["Item 0-0", "Item 0-1"],
        ["Item 1-0", "Item 1-1"],
        ["Item 2-0", "Item 2-1", "Item 2-2"]
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
        tableView.delegate = self
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
extension DragDropTableViewCellContoler: UITableViewDataSource {
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
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isDragDropAction {
            print("Item selected: \(data[indexPath.section][indexPath.row])")
        } else {
            print("Selection ignored during drag-and-drop.")
        }
    }
}

// MARK: - UITableViewDelegate Methods
extension DragDropTableViewCellContoler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Allow editing
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDragDelegate & UITableViewDropDelegate Methods
extension DragDropTableViewCellContoler: UITableViewDragDelegate, UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("itemsForBeginning")
        guard indexPath.section > 1 else {
            return []
        }

        isDragDropAction = true // Set the drag action flag

        let item = data[indexPath.section][indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item

        // Shrink the cell during drag
//        if let cell = tableView.cellForRow(at: indexPath) {
//            UIView.animate(withDuration: 0.3) {
//                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            }
//        }

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
            guard destinationIndexPath.section > 1 else {
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
//                    if let cell = tableView.cellForRow(at: destinationIndexPath) {
//                        UIView.animate(withDuration: 0.3) {
//                            cell.transform = CGAffineTransform.identity
//                        }
//                    }
                })

                coordinator.drop(coordinator.items.first!.dragItem, toRowAt: destinationIndexPath)
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

//        if destinationIndexPath.section == 0 || destinationIndexPath.section == 1 {
//            return UITableViewDropProposal(operation: .cancel)
//        }

        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        print("dropSessionDidEnd called")
        resetFlags() // Reset flags after the session ends

        // Reset cell states for all visible cells
//        tableView.visibleCells.forEach { cell in
//            UIView.animate(withDuration: 0.3) {
//                cell.transform = CGAffineTransform.identity
//            }
//        }
    }

    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return nil
    }
}
