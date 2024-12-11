//
//  CreateAndUpdateProductController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 29/11/24.
//

import UIKit

enum EnumCreateOrUpdate{
    case create
    case update
}

class CreateAndUpdateProductController: UIViewController, UIGestureRecognizerDelegate {
    
    
    let imgLog = UIImageView()
    let nameTextField = FloatingLabelTextField()
    let priceTextField = FloatingLabelTextField()
    let stockTextField = FloatingLabelTextField()
    let saveButton = MainButton()
    var nsConstraint = NSLayoutConstraint()
    
    var product : Product = Product() {
        didSet{
            if isEnumCreateOrUpdate == .update{
                nameTextField.text  = product.name
                priceTextField.text = "\(product.price)"
                stockTextField.text = "\(product.stockQuantity)"
                imgLog.image = product.photo.fromBase64String()
            }
        }
    }
    
    var isEnumCreateOrUpdate : EnumCreateOrUpdate = .create{
        didSet{
            
            if isEnumCreateOrUpdate == .update{
                saveButton.setTitle("Update", for: .normal)
                title = "Update Product"
            }else{
                saveButton.setTitle("Save", for: .normal)
                title = "Add Product"
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.leftBarButton()
        //Enable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Set up text fields
        nameTextField.title = "Product Name"
        priceTextField.title = "Price"
        stockTextField.title = "Stock Quantity"
        
        priceTextField.keyboardType = .decimalPad
        stockTextField.keyboardType = .numberPad
        
        imgLog.backgroundColor = .lightGray
        imgLog.layer.cornerRadius = 10
        imgLog.layer.borderWidth = 2
        imgLog.layer.borderColor = UIColor.mainBlueColor.cgColor
        imgLog.contentMode = .scaleAspectFit
        imgLog.clipsToBounds = true
        imgLog.isUserInteractionEnabled = true
        imgLog.addTapGesture(target: self, action: #selector(didTappedPhoto))
        
        
    
        let stackView = UIStackView(arrangedSubviews: [imgLog, nameTextField, priceTextField, stockTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(30, after: stockTextField)
        
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(stackView)

        saveButton.addTarget(self, action: #selector(saveProductTapped), for: .touchUpInside)
        
        nsConstraint =  scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        nsConstraint.isActive = true
        // Constraints
        NSLayoutConstraint.activate([
            scroll.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            scroll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
           
            
            stackView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor, constant: 0),
            
            imgLog.heightAnchor.constraint(equalToConstant: 200),
            
        ])
        
    }
    
    @objc func saveProductTapped() {
        
        let databaseManager = DatabaseManager()
        
        
        if isEnumCreateOrUpdate == .create {
            guard let name = nameTextField.text, !name.isEmpty,
                  let priceText = priceTextField.text, let price = Double(priceText),
                  let stockText = stockTextField.text, let stockQuantity = Int(stockText) ,
                  let img = imgLog.image?.toBase64String()
            else {
                // Handle error (e.g., show an alert)
                return
            }
            
            // Save the product (you should have a database manager already set up)
        
            databaseManager.createProduct(name: name, description: "", price: price, stockQuantity: stockQuantity, photo: img)
        }else{
            guard let name = nameTextField.text, !name.isEmpty,
                  let priceText = priceTextField.text, let price = Double(priceText),
                  let stockText = stockTextField.text, let stockQuantity = Int(stockText),
                  let img = imgLog.image?.toBase64String()
            else {
                // Handle error (e.g., show an alert)
                return
            }
            
            // Save the product (you should have a database manager already set up)
           
            databaseManager.updateProduct(id: product.id,
                                          name: name,
                                          price: price,
                                          stockQuantity: stockQuantity,
                                          photo: img)
        }
        
        

        
        // Go back to the previous screen
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func didTappedPhoto(){
        Loading.shared.showLoading()
        uploadQR()
//        let handleImage = HandleImage()
//        handleImage.uploadQR()
//        handleImage.handleSelectedImage = { img in
//            self.imgLog.image = img
//        }
        
    }

}

extension CreateAndUpdateProductController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
//    var handleSelectedImage:((_ image: UIImage)->())?
    
    @objc  func uploadQR() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Use .camera if you want to take a photo
        present(imagePicker, animated: true){
            Loading.shared.hideLoading()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        dismiss(animated: true, completion: {
            
            let img = selectedImage.toBase64String()
            
            let stringToImagee = img?.fromBase64String()
            
            self.imgLog.image = stringToImagee
            
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }



    
    
}



extension UIImage {
    
    // Convert UIImage to Base64 String
    func toBase64String() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1.0) else { return nil }
        return imageData.base64EncodedString()
    }

    // Convert Base64 String to UIImage

}

extension String {
     func fromBase64String() -> UIImage? {
        guard let imageData = Data(base64Encoded: self) else { return nil }
        return UIImage(data: imageData)
    }
}
