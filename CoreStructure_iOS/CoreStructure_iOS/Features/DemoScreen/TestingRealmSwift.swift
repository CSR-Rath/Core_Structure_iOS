import UIKit
import RealmSwift
import Combine

// MARK: - Models
class User: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var email: String = ""
}

class MenuItemsModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var userId: String = ""
    @Persisted var menuItemName: String = ""
}

struct SaveUserResponse {
    let user: User
}

// MARK: - View Controller
class UserViewController: UIViewController {
    
    // MARK: - UI Components
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let permissionsTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter permissions (comma separated)"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save User", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.tintColor = .white
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRealm()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "User Manager"
        
        let stackView = UIStackView(arrangedSubviews: [
            nameTextField,
            emailTextField,
            permissionsTextField,
            saveButton,
            activityIndicator,
            statusLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        saveButton.addTarget(self, action: #selector(saveUserTapped), for: .touchUpInside)
        
        // Set default test values
        nameTextField.text = "Test User"
        emailTextField.text = "test@example.com"
        permissionsTextField.text = "read"
    }
    
    private func setupRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true // For development only
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Actions
    @objc private func saveUserTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let permissionsText = permissionsTextField.text, !permissionsText.isEmpty else {
            showStatus("Please fill all fields", isError: true)
            return
        }
        
        let permissions = permissionsText.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        saveUser(name: name, email: email, permissions: permissions)
//        
        print("📁 Realm file location:")
//        Realm.Configuration.defaultConfiguration.fileURL


        if let file = Realm.Configuration.defaultConfiguration.fileURL{
            print("file: \(file)")
        }
        else{
            print("Nil")
        }
        
    }
    
    // MARK: - Business Logic
    private func saveUser(name: String, email: String, permissions: [String]) {
        activityIndicator.startAnimating()
        saveButton.isEnabled = false
        statusLabel.text = nil
        
        // Create user
        let user = User()
        user.name = name
        user.email = email
        
        // Create permissions
        let permissionList = permissions.map { permission -> MenuItemsModel in
            let item = MenuItemsModel()
            item.menuItemName = permission
            return item
        }
        
        saveUserInfo(user: user, permissionList: permissionList)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.activityIndicator.stopAnimating()
                self?.saveButton.isEnabled = true
                
                if case .failure(let error) = completion {
                    self?.showStatus("Error: \(error.localizedDescription)", isError: true)
                }
            } receiveValue: { [weak self] response in
                let message = """
                Saved successfully!
                User: \(response.user.name)
                Email: \(response.user.email)
                ID: \(response.user.id)
                Permissions: \(permissions.joined(separator: ", "))
                """
                self?.showStatus(message, isError: false)
                print("Saved user with permissions to Realm")
            }
            .store(in: &cancellables)
    }
    
    private func saveUserInfo(user: User, permissionList: [MenuItemsModel]) -> AnyPublisher<SaveUserResponse, Error> {
        return Deferred {
            Future<SaveUserResponse, Error> { promise in
                do {
                    let realm = try Realm()
                    try realm.write {
                        // Save or update user
                        let savedUser = realm.create(User.self, value: [
                            "id": user.id,
                            "name": user.name,
                            "email": user.email
                        ], update: .modified)
                        
                        // Delete old permissions
                        let existingPermissions = realm.objects(MenuItemsModel.self).filter("userId == %@", savedUser.id)
                        realm.delete(existingPermissions)
                        
                        // Add new permissions
                        let newPermissions = permissionList.map { item -> MenuItemsModel in
                            let newItem = MenuItemsModel()
                            newItem.id = UUID().uuidString
                            newItem.userId = savedUser.id
                            newItem.menuItemName = item.menuItemName
                            return newItem
                        }
                        realm.add(newPermissions, update: .modified)
                        
                        promise(.success(SaveUserResponse(user: savedUser)))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .eraseToAnyPublisher()
    }
    
    private func showStatus(_ message: String, isError: Bool) {
        statusLabel.text = message
        statusLabel.textColor = isError ? .systemRed : .systemGreen
    }
}

