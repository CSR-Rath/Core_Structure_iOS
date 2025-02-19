//
//  ScannerController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/11/24.
//

import UIKit
import AVFoundation


class ScannerController: UIViewController, UIGestureRecognizerDelegate  {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var currentInput: AVCaptureDeviceInput!
    private var currentDevice: AVCaptureDevice!
    private var metadataOutput: AVCaptureMetadataOutput!
    private var positionScan: CGRect!
    
    let  image = UIImageView()
    
    // Take a photo
    private var photoOutput: AVCapturePhotoOutput!
    
    
    // Configuration frame
    private let widthScan: CGFloat = 300
    private let heightScan: CGFloat = 350
    private let lineWidth: CGFloat = 350
    private let screen = UIScreen.main.bounds
    
    
    private let scannerLine = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scanner"
        view.backgroundColor =  .mainBlueColor
        //Enable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setupCGRect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let captureSession =  captureSession{
            if captureSession.isRunning == false {
                DispatchQueue.global(qos: .background).async {
                    captureSession.startRunning()
                    self.startScanAnimate()
                }
            }
        }
        else{
            checkCameraAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
       
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let captureSession =  captureSession{
            if (captureSession.isRunning) {
                captureSession.stopRunning()
                stopScanAnimate()
            }
        }
    }
    
    //MARK: Handle receive string
    private func found(code: String) {
        print("QR Code Found: \(code)")
        
        // Handle the scanned code, e.g., navigate to another view controller
    }

}


// MARK: - AVCapturePhotoCaptureDelegate
extension ScannerController: AVCapturePhotoCaptureDelegate {
    
    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        if let imgFullScreen = UIImage(data: imageData) {
            
            if let image =  cropToPreviewLayer(from: imgFullScreen, toSizeOf: positionScan){
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)// Save to photo library
                print("Photo captured and saved.")
                
                self.image.image = image
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
            
            let img = UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation) //.roundedImage()
            
            return img
        }else{
            return UIImage()
        }
    }
}


extension ScannerController:  AVCaptureMetadataOutputObjectsDelegate {
    
    private func setupCGRect(){
        
        positionScan = CGRect(x: (screen.width-widthScan)/2,
                              y: ((screen.height-heightScan)/2)-100,
                              width: widthScan,
                              height: heightScan)
    }
    
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
        
        // Start the capture session in a background thread to avoid blocking the main thread
        DispatchQueue.global(qos: .background).async { [self] in
            if captureSession.isRunning == false {
                captureSession.startRunning() // Start the capture session
                startScanAnimate() // Start any animations for scanning (like a moving line)
            }
        }
        
        // Set the rectangle of interest for QR code detection
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: positionScan)
        
        // Create an overlay for the scanner
        let overlay = createOverlay(position: positionScan)
        view.addSubview(overlay) // Add the overlay to the view
        
        scannerLine.backgroundColor = .orange
        view.addSubview(scannerLine)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            found(code: stringValue)
        
        }
    }
}

// MARK: Setup frame and animate line
extension ScannerController{
    
     private func startScanAnimate() {
        DispatchQueue.main.async { [self] in
            scannerLine.isHidden = false
            scannerLine.frame = CGRect(x: (screen.width-lineWidth)/2, y: positionScan.minY + 10  , width: lineWidth, height: 5)
            // withDuration : for animate for display
            // delay: for animate start first
            UIView.animate(withDuration: 1,
                           delay: 0.5,
                           options: [.curveLinear, .repeat, .autoreverse],
                           animations: { [self] in
                scannerLine.frame = CGRect(x: (screen.width-lineWidth)/2, y: positionScan.maxY - 10  , width: lineWidth, height: 5)
            }, completion: nil)
        }
    }
    
    private func stopScanAnimate() {
        self.scannerLine.isHidden = true
        self.scannerLine.layer.removeAllAnimations()
    }
    
    private func createOverlay(position: CGRect) -> UIView {
        
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = .mainBlueColor.withAlphaComponent(0.9)
        
        let path = CGMutablePath()
        path.addRoundedRect(in: position,
                            cornerWidth: 10,
                            cornerHeight: 10)
        path.closeSubpath()
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.lineWidth = 10
        shape.strokeColor = UIColor.mainBlueColor.cgColor
        
        overlayView.layer.addSublayer(shape)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        let btn = UIButton()
        btn.frame = CGRect(x: 100, y: 550, width: 200, height: 50)
        btn.setTitle("Switch Camera", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        overlayView.addSubview(btn)
        
        let btnFlash = UIButton()
        btnFlash.frame = CGRect(x: 100, y: 600, width: 200, height: 50)
        btnFlash.setTitle("Flash", for: .normal)
        btnFlash.setTitleColor(.white, for: .normal)
        btnFlash.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        overlayView.addSubview(btnFlash)
        
        let btnTakePhoto = UIButton()
        btnTakePhoto.frame = CGRect(x: 100, y: 650, width: 200, height: 50)
        btnTakePhoto.setTitle("Take a Photo", for: .normal)
        btnTakePhoto.setTitleColor(.white, for: .normal)
        btnTakePhoto.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        overlayView.addSubview(btnTakePhoto)
        
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.backgroundColor = .red
        image.frame = CGRect(x: 200, y: 720, width: 150, height: 150)
        overlayView.addSubview(image)
        
        let btnUploadQR = UIButton()
        btnUploadQR.setTitle("Upload QR", for: .normal)
        btnUploadQR.setTitleColor(.white, for: .normal)
        btnUploadQR.frame = CGRect(x: 200, y: 670, width: 150, height: 150)
        btnUploadQR.addTarget(self, action: #selector(uploadQR), for: .touchUpInside)
        overlayView.addSubview(btnUploadQR)
        
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
    
}

//MARK: - Upload QRCode
extension ScannerController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc private func uploadQR() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Use .camera if you want to take a photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        dismiss(animated: true, completion: {
           print("Image selected for QR code processing.")
            self.found(code: selectedImage.imageToString())
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}


