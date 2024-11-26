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
    private var positionScan: CGRect!
    
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
            DispatchQueue.main.async {
                self.showPermissionDeniedAlert()
            }
        @unknown default:
            break
        }
        
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(title: "Camera Access Denied",
                                      message: "Please enable camera access in Settings to use the scanner.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true)
    }
    
    private func setupScanner() {
        
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        currentDevice = videoCaptureDevice
        
        
        do {
            currentInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(currentInput)) {
            captureSession.addInput(currentInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr] // Scanning for QR codes
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        let overlay = createOverlay(position: positionScan)
        view.addSubview(overlay)
        
        print("positionScan == > \(positionScan!)")
        
        
        scannerLine.backgroundColor = .orange
        scannerLine.layer.cornerRadius = 2.5
        scannerLine.frame = CGRect(x: (screen.width-lineWidth)/2, y: positionScan.maxY - 10  , width: lineWidth, height: 5)
        view.addSubview(scannerLine)
        
        
        DispatchQueue.global(qos: .background).async { [self] in
            if captureSession.isRunning == false {
                captureSession.startRunning()
                startScanAnimate()
            }
        }
        
        
        
        // MARK: Setup position scanner
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: positionScan)
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


// MARK: Setup frame
extension ScannerController{
    
    @objc func startScanAnimate() {
        DispatchQueue.main.async { [self] in
            scannerLine.isHidden = false
            scannerLine.frame = CGRect(x: (screen.width-lineWidth)/2, y: positionScan.minY + 10  , width: lineWidth, height: 5)
            // withDuration : for animate for display
            // delay: for animate start first
            UIView.animate(withDuration: 2,
                           delay: 0.5,
                           options: [.curveLinear, .repeat, .autoreverse],
                           animations: { [self] in
                scannerLine.frame = CGRect(x: (screen.width-lineWidth)/2, y: positionScan.maxY - 10  , width: lineWidth, height: 5)
            }, completion: nil)
        }

    }
    
    func stopScanAnimate() {
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
       

        
        return overlayView
    }
    
    @objc func toggleFlash() {
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
    
    @objc  func toggleCamera() {
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





