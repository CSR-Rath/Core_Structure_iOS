//
//  NIDScannerVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 1/4/25.
//

import UIKit
import AVFoundation

class NIDScannerVC: UIViewController, UIGestureRecognizerDelegate  {
    
    // Manages the entire camera session (starting/stopping capture)
    private var captureSession: AVCaptureSession!
    // Displays the live camera preview on screen
    private var previewLayer: AVCaptureVideoPreviewLayer!
    // Represents the input device (camera) used for capturing video or photos
    private var currentInput: AVCaptureDeviceInput!
    // Represents the physical camera hardware (front or rear camera)
    private var currentDevice: AVCaptureDevice!
    // Handles metadata detection (used for QR code/barcode scanning)
    private var metadataOutput: AVCaptureMetadataOutput!
    // Handles photo capture functionality
    private var photoOutput: AVCapturePhotoOutput!
    
    /// position view camera
    private var positionScan: CGRect!
    private let imgTakePhoto = UIImageView() // upload take image e.g NID
    private let scannerLine = UIImageView()
    
    // Configuration frame size
    private let cornerRadius: CGFloat = 5
    private let cornerSize: CGFloat = 50
    private let widthScan: CGFloat = UIScreen.main.bounds.width - 40
    private let heightScan: CGFloat = 270
    private let lineWidth: CGFloat = 350 // width line animation
    private let lineHeight: CGFloat = 5 // height line animation
    private let screen = UIScreen.main.bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scanner"
        
        view.backgroundColor =  .black
        //Enable back swipe gesture

        
        positionScan = CGRect(x: (screen.width-widthScan)/2,
                              y: ((screen.height-heightScan)/2)-150,
                              width: widthScan,
                              height: heightScan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if  captureSession != nil{
            startVideo()
        }
        else{
            checkCameraAuthorization()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopVideo()
    }
    
    private func startVideo(){
        if captureSession.isRunning == false {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
                self.startScanAnimate()
            }
        }
    }
    
    private func stopVideo(){
        
        if let captureSession =  captureSession{
            if (captureSession.isRunning) {
                captureSession.stopRunning()
                stopScanAnimate()
            }
        }
        
    }
    
    //MARK: Handle receive string
    private func getStringQRCodefound(code: String) {
        
        Loading.shared.hideLoading()
        print("QR Code Found: \(code)")
        
        /// if invalid qr
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
}

extension NIDScannerVC:  AVCaptureMetadataOutputObjectsDelegate {
    
    private func checkCameraAuthorization() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupScanner()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setupScanner()
                    } else {
                        self.showPermissionDeniedAlert()
                    }
                }
            }
        case .denied, .restricted:
            
            self.showPermissionDeniedAlert()
            
        @unknown default:
            break
        }
    }
    
    private func showPermissionDeniedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Camera Access Denied",
                                          message: "Please enable camera access in Settings to use the scanner.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            self.present(alert, animated: true)
        }
    }
    
    private func setupScanner() {
        // Initialize the capture session
        captureSession = AVCaptureSession()
        
        // Get the default video capture device (the camera)
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        currentDevice = videoCaptureDevice // Store the current camera device
        
        do {
            // Try to create a video input from the capture device
            currentInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return // Handle errors if input creation fails
        }
        
        // Add the video input to the capture session if possible
        if (captureSession.canAddInput(currentInput)) {
            captureSession.addInput(currentInput)
        } else {
            return // Handle the case where input cannot be added
        }
        
        // Create and configure the metadata output for QR code scanning
        metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            // Set the delegate to receive metadata output
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // Specify that we are interested in QR codes
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return // Handle the case where output cannot be added
        }
        
        // Setup photo output for capturing photos
        photoOutput = AVCapturePhotoOutput()
        if (captureSession.canAddOutput(photoOutput)) {
            captureSession.addOutput(photoOutput)
        } else {
            return // Handle the case where photo output cannot be added
        }
        
        // Create the preview layer to show the camera input on the screen
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer) // Add the preview layer to the view
        
        
        print("positionScan == > \(positionScan!)")
        
        startVideo()
        
        // Set the rectangle of interest for QR code detection
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: positionScan)
        
        // Create an overlay for the scanner
        let overlay = createOverlay()
        view.addSubview(overlay) // Add the overlay to the view
        
        scannerLine.backgroundColor = .orange
        view.addSubview(scannerLine)
    }
    
}

// MARK: Setup frame, animate line, action button
extension NIDScannerVC{
    
    private func startScanAnimate() {
        DispatchQueue.main.async { [self] in
            scannerLine.isHidden = false
            scannerLine.frame = CGRect(x: (screen.width-lineWidth)/2,
                                       y: positionScan.minY + cornerSize  ,
                                       width: lineWidth,
                                       height: lineHeight)
            /// withDuration : for animate for display
            /// delay: for animate start first
            UIView.animate(withDuration: 1.4, // duration animation
                           delay: 0.2,
                           options: [.curveLinear, .repeat, .autoreverse],
                           animations: { [self] in
                scannerLine.frame = CGRect(x: (screen.width-lineWidth)/2,
                                           y: positionScan.maxY - cornerSize - lineHeight ,
                                           width: lineWidth,
                                           height: lineHeight)
            }, completion: nil)
        }
    }
    
    private func stopScanAnimate() {
        self.scannerLine.isHidden = true
        self.scannerLine.layer.removeAllAnimations()
    }
    
    private func createOverlay() -> UIView {
        
        let overlayView = BlurredBackgroundView()
        overlayView.frame = view.bounds
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        overlayView.alpha = 0.99
        
        
        let topLeft = UIView()
        topLeft.roundCorners(corners: [.topLeft], radius: cornerRadius)
        
        let topRight = UIView()
        topRight.roundCorners(corners: [.topRight], radius: cornerRadius)
        
        let bottomLeft = UIView()
        bottomLeft.roundCorners(corners: [.bottomLeft], radius: cornerRadius)
        
        let bottomRight = UIView()
        bottomRight.roundCorners(corners: [.bottomRight], radius: cornerRadius)
        
        
        let allViewFrame : [UIView] = [
            topLeft,
            topRight,
            bottomLeft,
            bottomRight
        ]
        
        allViewFrame.forEach({ item in
            item.backgroundColor = .white
            item.layer.cornerRadius = cornerRadius
            item.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(item)
        })
        
        // Corrected constraints
        NSLayoutConstraint.activate([
            
            topLeft.widthAnchor.constraint(equalToConstant: cornerSize),
            topLeft.heightAnchor.constraint(equalToConstant: cornerSize),
            topLeft.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: positionScan.minY - cornerRadius),
            topLeft.leftAnchor.constraint(equalTo: overlayView.leftAnchor, constant: positionScan.minX - cornerRadius),
            
            topRight.widthAnchor.constraint(equalToConstant: cornerSize),
            topRight.heightAnchor.constraint(equalToConstant: cornerSize),
            topRight.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: positionScan.minY - 5),
            topRight.rightAnchor.constraint(equalTo: overlayView.leftAnchor, constant: positionScan.maxX +  cornerRadius),
            
            bottomLeft.widthAnchor.constraint(equalToConstant: cornerSize),
            bottomLeft.heightAnchor.constraint(equalToConstant: cornerSize),
            bottomLeft.bottomAnchor.constraint(equalTo: overlayView.topAnchor, constant: positionScan.maxY + cornerRadius),
            bottomLeft.leftAnchor.constraint(equalTo: overlayView.leftAnchor, constant: positionScan.minX - cornerRadius),
            
            bottomRight.widthAnchor.constraint(equalToConstant: cornerSize),
            bottomRight.heightAnchor.constraint(equalToConstant: cornerSize),
            bottomRight.bottomAnchor.constraint(equalTo: overlayView.topAnchor, constant: positionScan.maxY  + cornerRadius),
            bottomRight.rightAnchor.constraint(equalTo: overlayView.leftAnchor, constant: positionScan.maxX  + cornerRadius)
        ])
        
        
        let btnSwitchCamera = UIButton()
        btnSwitchCamera.setTitle("Switch Camera", for: .normal)
        btnSwitchCamera.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        // ---
        let btnFlash = UIButton()
        btnFlash.setTitle("Flash", for: .normal)
        btnFlash.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        // ---
        let btnTakePhoto = UIButton()
        btnTakePhoto.setTitle("Take a Photo", for: .normal)
        btnTakePhoto.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        // ---
        let btnUploadQR = UIButton()
        btnUploadQR.setTitle("Upload", for: .normal)
        btnUploadQR.addTarget(self, action: #selector(uploadQR), for: .touchUpInside)
        //--
        imgTakePhoto.contentMode = .scaleAspectFill
        imgTakePhoto.layer.cornerRadius = 10
        imgTakePhoto.backgroundColor = .lightGray
        overlayView.addSubview(imgTakePhoto)
        
        let allViewButton : [UIButton] = [
            btnSwitchCamera,
            btnFlash,
            btnTakePhoto,
            btnUploadQR
        ]
        
        allViewButton.forEach({ item in
            item.setTitleColor(.white, for: .normal)
        })
        
        let stackButton = UIStackView(arrangedSubviews: [
            imgTakePhoto,
            btnSwitchCamera,
            btnFlash,
            btnTakePhoto,
            btnUploadQR
        ])
        
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.axis = .vertical
        stackButton.spacing = 15
        stackButton.alignment = .center
        stackButton.distribution = .fill
        overlayView.addSubview(stackButton)
        
        NSLayoutConstraint.activate([
            
            stackButton.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -30),
            stackButton.leftAnchor.constraint(equalTo: overlayView.leftAnchor, constant: 0),
            stackButton.rightAnchor.constraint(equalTo: overlayView.rightAnchor, constant: 0),
            
            imgTakePhoto.heightAnchor.constraint(equalToConstant: 120),
            imgTakePhoto.widthAnchor.constraint(equalToConstant: 120),
            
        ])
        
        // Create a transparent area (cutout)
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size)) // Outer rect
        path.addRoundedRect(in: positionScan!,
                            cornerWidth: 0,
                            cornerHeight: 0) // Transparent area
        path.closeSubpath()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        maskLayer.backgroundColor = UIColor.black.cgColor
        overlayView.layer.mask = maskLayer
        return overlayView
    }
    
    @objc private func toggleFlash() {
        guard let device = currentDevice else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                // Toggle the torch mode
                if device.torchMode == .on {
                    device.torchMode = .off
                } else {
                    try device.setTorchModeOn(level: 1.0) // Set level between 0.0 and 1.0
                }
                device.unlockForConfiguration()
            } catch {
                print("Error toggling flash: \(error)")
            }
        }
    }
    
    @objc private func toggleCamera() {
        guard let currentInput = currentInput else { return }
        
        // Determine the new camera position
        let newPosition: AVCaptureDevice.Position = (currentInput.device.position == .back) ? .front : .back
        
        // Find the new device
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else { return }
        
        // Remove the current input
        captureSession.beginConfiguration()
        captureSession.removeInput(currentInput)
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newDevice)
            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
                self.currentInput = newInput // Update the current input
                currentDevice = newDevice // Update the current device
            } else {
                // If we can't add the new input, add the old one back
                captureSession.addInput(currentInput)
            }
        } catch {
            print("Error switching cameras: \(error)")
        }
        
        captureSession.commitConfiguration()
    }
    
    /// scanner qrcode action func
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            getStringQRCodefound(code: stringValue)
            
        }
    }
    
}

//MARK: - Upload QRCode
extension NIDScannerVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc private func uploadQR() {
        Loading.shared.showLoading()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Use .camera if you want to take a photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// didSelect upload qrcode
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        dismiss(animated: true, completion: {
            print("Image selected for QR code processing.")
            self.getStringQRCodefound(code: selectedImage.imageToString())
        })
    }
    
    /// cancel button on present images
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            Loading.shared.hideLoading()
        }
    }
}

//MARK: - take photo camera
extension NIDScannerVC: AVCapturePhotoCaptureDelegate {
    
    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    // get image when take photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        if let imgFullScreen = UIImage(data: imageData) {
            
            if let image =  cropToPreviewLayer(from: imgFullScreen, toSizeOf: positionScan){
//                stopVideo()
                print("Photo captured and saved.")
                self.imgTakePhoto.image = image
            }else{
                print("Image is nil")
            }
        }
    }
    
    private func cropToPreviewLayer(from originalImage: UIImage, toSizeOf rect: CGRect) -> UIImage? {
        guard let cgImage = originalImage.cgImage else { return nil }
        
        // This previewLayer is the AVCaptureVideoPreviewLayer which the resizeAspectFill and videoOrientation portrait has been set.
        let outputRect = previewLayer?.metadataOutputRectConverted(fromLayerRect: rect)
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        
        
        let cropRect = CGRect(x: ((outputRect?.origin.x ?? 0) * width),
                              y: ((outputRect?.origin.y ?? 0) * height),
                              width: ((outputRect?.size.width ?? 0) * width),
                              height: ((outputRect?.size.height ?? 0) * height))
        
        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            //            let img = UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation)
            /// cricle
            let img = UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation).roundedImage()
            return img
        }else{
            return UIImage()
        }
    }
}


