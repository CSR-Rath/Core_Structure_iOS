//
//  UploadImageManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/4/25.
//

import Foundation
import UIKit
import AVFoundation


enum UploadImageEnum{
    case isUploadProfile
    case isUploadProductImage
}

class BaseUIImagePickerController: NSObject,
                                   UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate {
    
    private var pickerController: UIImagePickerController!
    
    var didPickImage: ((_ image: UIImage, _ heightPercentage: CGFloat) -> Void)?
    
    var uploadImage: UploadImageEnum = .isUploadProductImage
    
    // MARK: - Done Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            
            if let editedImage = info[.editedImage] as? UIImage {
                print("editedImage ==>")
                var aspectRatio = editedImage.size.height / editedImage.size.width
                if aspectRatio > 1 {
                    aspectRatio = 1
                }
                self.didPickImage?(editedImage, aspectRatio)
            }
            else if let originalImage = info[.originalImage] as? UIImage {
                print("originalImage ==>")
                var aspectRatio = originalImage.size.height / originalImage.size.width
                if aspectRatio > 1 {
                    aspectRatio = 1
                }
                self.didPickImage?(originalImage, aspectRatio)
            }
            
        }
    }
}

// MARK: - Action Button
extension BaseUIImagePickerController{
    
    func presentChooseOption(from viewController: UIViewController) {
        
        let alert = UIAlertController(title: "Select Image", message: "Choose an option", preferredStyle: .actionSheet)
        
        // Take Photo option
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
                self?.requestCameraPermissionAndPresent(from: viewController)
            }))
        }
        
        // Choose from Library option
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary(from: viewController)
        }))
        
        // Cancel option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // iPad popover support
        if let popover = alert.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                        y: viewController.view.bounds.midY,
                                        width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController.present(alert, animated: true)
    }
    
    private  func presentPhotoLibrary(from viewController: UIViewController) {
        pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.modalPresentationStyle = .fullScreen
        viewController.present(pickerController, animated: true)
    }
    
    
    private func presentCamera(from viewController: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        pickerController.modalPresentationStyle = .fullScreen
        viewController.present(pickerController, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Permission request
extension BaseUIImagePickerController{
    
    private func requestCameraPermissionAndPresent(from viewController: UIViewController) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Already authorized
            presentCamera(from: viewController)
            
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.presentCamera(from: viewController)
                    } else {
                        self?.showPermissionDeniedAlert(from: viewController)
                    }
                }
            }
            
        case .denied, .restricted:
            // Permission denied or restricted
            showPermissionDeniedAlert(from: viewController)
            
        @unknown default:
            // Future cases
            break
        }
    }
    
    private func showPermissionDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Camera Permission Denied",
            message: "Please enable camera access in Settings to take photos.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        viewController.present(alert, animated: true)
    }
}


