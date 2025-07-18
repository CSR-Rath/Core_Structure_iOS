//
//  SignatureViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/3/25.
//

import UIKit

class SignatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

class SignatureView: UIView {

    var lineColor: UIColor = .black
    var lineWidth: CGFloat = 3
    private var path = UIBezierPath()
    private var touchPoint: CGPoint?
    private var startingPoint: CGPoint?

    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.red.cgColor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        startingPoint = touch.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let startingPoint = startingPoint else { return }
        touchPoint = touch.location(in: self)
        
        path.move(to: startingPoint)
        path.addLine(to: touchPoint!)
        self.startingPoint = touchPoint
        
        drawShapeLayer()
    }

    private func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor

        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }

    func clearDraw() {
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }

    func getSignatureImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let signatureImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return signatureImage
    }
}

class Sign: UIViewController {


    private let signatureView = SignatureView()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Signature"
        view.backgroundColor = .white
        setupView()
        setupActions()
    }

    private func setupView() {
        view.addSubview(signatureView)
        view.addSubview(clearButton)
        view.addSubview(saveButton)

        signatureView.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            // Signature View Constraints
            signatureView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            signatureView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            signatureView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 16),
            signatureView.heightAnchor.constraint(equalToConstant: 300),

            // Clear Button Constraints
            clearButton.leadingAnchor.constraint(equalTo: signatureView.leadingAnchor),
            clearButton.topAnchor.constraint(equalTo: signatureView.bottomAnchor, constant: 10),
            clearButton.trailingAnchor.constraint(equalTo: signatureView.centerXAnchor, constant: -10),
            clearButton.heightAnchor.constraint(equalToConstant: 40),

            // Save Button Constraints
            saveButton.leadingAnchor.constraint(equalTo: signatureView.centerXAnchor, constant: 10),
            saveButton.topAnchor.constraint(equalTo: signatureView.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: signatureView.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupActions() {
        clearButton.addTarget(self, action: #selector(clearSignature), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveSignature), for: .touchUpInside)
    }

    @objc private func clearSignature() {
        signatureView.clearDraw()
    }

    @objc private func saveSignature() {
        guard let signatureImage = signatureView.getSignatureImage() else { return }

        let alert = UIAlertController(title: "Save Signature",
                                      message: "Where do you want to save the signature?",
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Save to Photos",
                                      style: .default,
                                      handler: { _ in
            self.saveToPhotos(image: signatureImage)
        }))


        alert.addAction(UIAlertAction(title: "Save to Photos",
                                      style: .default,
                                      handler: { _ in
            
            if let imageData = signatureImage.pngData() {
                print("PNG Data Size: \(imageData.count) bytes")
                FileDownloaderManager.shared.shareFile(data: imageData, doc_name: "Testing.png")
            }

            if let jpegData = signatureImage.jpegData(compressionQuality: 0.8) {
                print("JPEG Data Size: \(jpegData.count) bytes")
                FileDownloaderManager.shared.shareFile(data: jpegData, doc_name: "Testing.jpeg")
            }

        }))


        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))

        present(alert, animated: true)
    }

    private func saveToPhotos(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }

    @objc private func imageSaved(_ image: UIImage,
                                  didFinishSavingWithError error: NSError?,
                                  contextInfo: UnsafeRawPointer) {
        
        let alert = UIAlertController(title: error == nil ? "Success" : "Error",
                                      message: error == nil ? "Signature saved to Photos." : error?.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    

    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
