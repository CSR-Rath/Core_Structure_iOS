//
//  UploadImageManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/4/25.
//

import Foundation
import UIKit

class UploadImageManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var pickerController: UIImagePickerController!
    private weak var presentingVC: UIViewController?
    
    var didPickImage: ((_ image: UIImage, _ heightPercentage: CGFloat) -> Void)?
    
    func presentImagePicker(from viewController: UIViewController) {
        self.presentingVC = viewController
        
        pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true // Enable cropping
        
        viewController.present(pickerController, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let editedImage = info[.editedImage] as? UIImage {
                
                var  aspectRatio = editedImage.size.height / editedImage.size.width
                
                if aspectRatio > 1{
                    aspectRatio = 1
                }
                
                self.didPickImage?(editedImage, aspectRatio)
            } else if let originalImage = info[.originalImage] as? UIImage {
                
                var  aspectRatio = originalImage.size.height / originalImage.size.width
                
                if aspectRatio > 1{
                    aspectRatio = 1
                }
                
                self.didPickImage?(originalImage, aspectRatio)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}







