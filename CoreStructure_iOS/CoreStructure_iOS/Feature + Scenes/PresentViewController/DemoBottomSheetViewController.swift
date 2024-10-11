import UIKit

class DemoBottomSheetViewController: BottomSheetViewController {
    
        private let headerImageView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor  = .red
            view.heightAnchor.constraint(equalToConstant: 300).isActive = true
            return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setContent(content: headerImageView)

    }
}
