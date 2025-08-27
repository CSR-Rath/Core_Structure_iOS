//
//  SceneDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit

let statusBarFrame = 0
let navigationBarFrame = 0

//✅ Yes. You can use SwiftUI inside UIKit (UIHostingController) or UIKit inside SwiftUI (UIViewRepresentable). Many real-world projects mix both.


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static let shared = SceneDelegate()
    
    internal var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        networkMonitoring()
        setupNavigationBarAppearance()
        rootViewController(scene: scene)
    }
    
    private func rootViewController(scene: UIScene){
        
        let loginSuccessfully = UserDefaults.standard.bool(forKey: AppConstants.loginSuuccess)
        let controller: UIViewController = SplashScreenVC()
        
        let navigation = UINavigationController(rootViewController: controller)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window!.rootViewController = navigation
        window!.makeKeyAndVisible()
        window!.overrideUserInterfaceStyle = .light
        
    }
    
    
    private func setupNavigationBarAppearance(){
        AppManager.shared.setCustomNavigationBarAppearance(titleColor: .red,
                                                           titleColorScrolling: .white,
                                                           barAppearanceColor: .clear,
                                                           barAppearanceScrollingColor: .clear,
                                                           shadowColorLine: .clear)
    }
    
    private func networkMonitoring(){
        NetworkMonitorManager.shared.onStatusChange = { isConnected in
            
            if isConnected {
                print("✅ Internet connected")
                
            } else {
                print("❌ Internet disconnected")
                
            }
        }
    }
    
    func changeRootViewController(to controller: UIViewController, 
                                  animated: Bool = true) {
        
        guard let window = self.window else { return }
        
        // Optional: wrap in navigation controller if needed
        let nav = UINavigationController(rootViewController: controller)
        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = nav
            })
        } else {
            window.rootViewController = nav
        }
        
    }
    
    func statusBarColor(color: UIColor){
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController as? UINavigationController
        else { return }

        let navigationBarFrame = rootVC.navigationBar.frame

        if let statusBarFrame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame {
            let statusBarView = UIView(frame: statusBarFrame)
            statusBarView.backgroundColor = color
            UIApplication.shared.windows.first?.addSubview(statusBarView)
        }
        
    }
}


// MARK: - App lifecycle
extension SceneDelegate {
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground") // App is coming to the foreground but not yet active. (From background)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive") // App is now active and interactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive") // App is about to move from active to inactive (e.g., user pressed Home button).
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground") // App is now in the background but not terminated.
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect") // Scene is removed (e.g., app is fully closed or scene is discarded).
    }
}




// MARK: - Global variable
var windowSceneDelegate: UIWindow!
var barAppearanHeight: CGFloat!
var bottomSafeAreaInsetsHeight: CGFloat!
let screen = UIScreen.main.bounds
let igorneSafeAeaTop: CGRect = CGRect(x: 0,
                                      y: Int(barAppearanHeight),
                                      width: Int(screen.width),
                                      height: Int(screen.height-barAppearanHeight))
func printFontsName(){
    
    for family in UIFont.familyNames {
        print("Font Family: \(family)")
        for fontName in UIFont.fontNames(forFamilyName: family) {
            print("    \(fontName)")
        }
    }
}


class CropImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let slider = UISlider()
    private let overlay = UIView()
    
    private let cancelButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let uploadButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupImageView()
        setupOverlay()
        setupSlider()
        setupButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update overlay mask whenever layout changes
        let path = UIBezierPath(rect: overlay.bounds)
        let circlePath = UIBezierPath(ovalIn: overlay.bounds)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        overlay.layer.mask = maskLayer
    }
    
    // MARK: - ScrollView Setup
    private func setupScrollView() {
        scrollView.backgroundColor = .cyan.withAlphaComponent(0.8)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        scrollView.addSubview(imageView)
    }
    
    // MARK: - Circular Mask Overlay
    private func setupOverlay() {
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.isUserInteractionEnabled = false
        overlay.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
        view.addSubview(overlay)
        
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: scrollView.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: - Slider Setup
    private func setupSlider() {
        let iconLeft = UIImageView(image: UIImage(systemName: "photo"))
        let iconRight = UIImageView(image: UIImage(systemName: "photo.fill"))
        
        [iconLeft, iconRight].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .orange
            view.addSubview($0)
        }
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 1.0
        slider.maximumValue = 5.0
        slider.value = 1.0
        slider.tintColor = .orange
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            iconLeft.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            iconLeft.centerYAnchor.constraint(equalTo: slider.centerYAnchor),
            iconLeft.widthAnchor.constraint(equalToConstant: 24),
            iconLeft.heightAnchor.constraint(equalToConstant: 24),
            
            iconRight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            iconRight.centerYAnchor.constraint(equalTo: slider.centerYAnchor),
            iconRight.widthAnchor.constraint(equalToConstant: 24),
            iconRight.heightAnchor.constraint(equalToConstant: 24),
            
            slider.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraint(equalTo: iconLeft.trailingAnchor, constant: 10),
            slider.trailingAnchor.constraint(equalTo: iconRight.leadingAnchor, constant: -10)
        ])
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
        scrollView.setZoomScale(CGFloat(sender.value), animated: false)
    }
    
    // MARK: - Buttons Setup
    private func setupButtons() {
        [cancelButton, doneButton, uploadButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 10
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.orange, for: .normal)
        cancelButton.layer.borderColor = UIColor.orange.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .orange
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.setTitleColor(.orange, for: .normal)
        uploadButton.layer.borderColor = UIColor.orange.cgColor
        uploadButton.layer.borderWidth = 1
        uploadButton.addTarget(self, action: #selector(pickImageFromGallery), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [cancelButton, doneButton, uploadButton])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    // MARK: - Image Picker
    @objc private func pickImageFromGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        // Reset scrollView zoom and contentInset/contentOffset before layout update
        scrollView.zoomScale = 1.0
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
        
        let scrollFrame = scrollView.bounds.size
        let imageRatio = image.size.width / image.size.height
        let viewRatio = scrollFrame.width / scrollFrame.height
        
        var imageSize: CGSize
        if imageRatio > viewRatio {
            imageSize = CGSize(width: scrollFrame.width, height: scrollFrame.width / imageRatio)
        } else {
            imageSize = CGSize(width: scrollFrame.height * imageRatio, height: scrollFrame.height)
        }
        
        imageView.frame = CGRect(origin: .zero, size: imageSize)
        scrollView.contentSize = imageSize
        
        // Recalculate minimum zoom scale
        let scaleW = scrollFrame.width / imageSize.width
        let scaleH = scrollFrame.height / imageSize.height
        let minScale = max(scaleW, scaleH)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 5.0 // keep this consistent
        scrollView.zoomScale = minScale
        
        slider.minimumValue = Float(minScale)
        slider.maximumValue = 5.0
        slider.value = Float(minScale)
        
        centerImage()
    }
    
    
    //    func imagePickerController(_ picker: UIImagePickerController,
    //                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    //        picker.dismiss(animated: true)
    //        if let image = info[.originalImage] as? UIImage {
    //            imageView.image = image
    //
    //            let scrollFrame = scrollView.bounds.size
    //            let imageRatio = image.size.width / image.size.height
    //            let viewRatio = scrollFrame.width / scrollFrame.height
    //
    //            var imageSize: CGSize
    //            if imageRatio > viewRatio {
    //                imageSize = CGSize(width: scrollFrame.width, height: scrollFrame.width / imageRatio)
    //            } else {
    //                imageSize = CGSize(width: scrollFrame.height * imageRatio, height: scrollFrame.height)
    //            }
    //
    //            imageView.frame = CGRect(origin: .zero, size: imageSize)
    //            scrollView.contentSize = imageSize
    //            centerImage()
    //
    //            let scaleW = scrollFrame.width / imageSize.width
    //            let scaleH = scrollFrame.height / imageSize.height
    //            let minScale = max(scaleW, scaleH)
    //
    //            scrollView.minimumZoomScale = minScale
    //            scrollView.zoomScale = minScale
    //            slider.minimumValue = Float(minScale)
    //            slider.value = Float(minScale)
    //        }
    //    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    // MARK: - Center Image
    private func centerImage() {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    // MARK: - Button Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        guard imageView.image != nil else {
            print("No image selected")
            return
        }
        
        guard let cropped = cropCircleImage() else {
            print("Cropping failed")
            return
        }
        
        let resultVC = UIViewController()
        resultVC.view.backgroundColor = .white
        
        let resultImageView = UIImageView(image: cropped)
        resultImageView.contentMode = .scaleAspectFit
        resultImageView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        resultImageView.center = resultVC.view.center
        resultVC.view.addSubview(resultImageView)
        
        present(resultVC, animated: true)
    }
    
    // MARK: - Crop Logic
    private func cropCircleImage() -> UIImage? {
        guard let image = imageView.image else { return nil }
        
        let imageSize = image.size
        let imageViewSize = imageView.frame.size
        
        let scaleX = imageSize.width / imageViewSize.width
        let scaleY = imageSize.height / imageViewSize.height
        
        let visibleRect = CGRect(
            x: scrollView.contentOffset.x * scaleX,
            y: scrollView.contentOffset.y * scaleY,
            width: scrollView.bounds.width * scaleX,
            height: scrollView.bounds.height * scaleY
        )
        
        guard let cgImage = image.cgImage?.cropping(to: visibleRect) else { return nil }
        let croppedImage = UIImage(cgImage: cgImage)
        
        // Crop to circle
        let diameter = min(croppedImage.size.width, croppedImage.size.height)
        let squareRect = CGRect(
            x: (croppedImage.size.width - diameter) / 2,
            y: (croppedImage.size.height - diameter) / 2,
            width: diameter,
            height: diameter
        )
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, croppedImage.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.addEllipse(in: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        context.clip()
        
        croppedImage.draw(at: CGPoint(x: -squareRect.origin.x, y: -squareRect.origin.y))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}

// MARK: - UIScrollViewDelegate
extension CropImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
        slider.value = Float(scrollView.zoomScale)
    }
}

