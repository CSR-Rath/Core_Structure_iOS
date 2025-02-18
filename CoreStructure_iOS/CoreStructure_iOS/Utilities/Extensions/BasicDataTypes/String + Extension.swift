//
//  String.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation
import UIKit


//MARK: ==================== Handle localize ====================

func setLanguage(langCode: LanguageEnum) {
    UserDefaults.standard.setValue(langCode.rawValue, forKey: KeyUser.language)
}

extension String {
    
    func getLangauge()->String{
        return UserDefaults.standard.string(forKey: KeyUser.language) ?? "en"
    }
    
    func localizeString() -> String {
        let lang = UserDefaults.standard.string(forKey: KeyUser.language)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}

//MARK: ==================== End handle localize ====================




//MARK: ==================== Handle webview ====================

//lazy var descriptionLbl: UITextView = {
//    let textView = UITextView()
//    textView.translatesAutoresizingMaskIntoConstraints = false
//    textView.textColor = .white
//    textView.backgroundColor = .clear//.mainColor
//    textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
//    textView.attributedText = "".htmlToAttributedString
//    textView.isEditable = false
//    textView.showsVerticalScrollIndicator = false
//    textView.isScrollEnabled = false
//    return textView
//}()

extension String{ // HTML to string
    
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        var attribStr = NSMutableAttributedString()
        do {
            
            attribStr = try NSMutableAttributedString(data: data,
                                                      options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding:String.Encoding.utf8.rawValue],
                                                      documentAttributes: nil)
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            
            let textRangeForFont : NSRange = NSMakeRange(0, attribStr.length)
            attribStr.addAttributes([ 
                NSAttributedString.Key.foregroundColor:UIColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font:font], range: textRangeForFont)
            
        } catch {
            return NSAttributedString()
        }
        
        return attribStr
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

//MARK: ==================== End handle webview ====================

enum DateFormat: String {
    
    case time = "h:mm a"  /// Time format (e.g., 5:30 PM)
   
    case short = "dd-MM-yyyy"  /// Short date format (e.g., 31/12/2023)
    case shortSlash = "dd/MM/yyyy"  /// Short date format (e.g., 31/12/2023)
 
    case medium = "dd-MMMM-yyyy"   /// Medium date format (e.g., 31-December-2023)
    case mediumSlash = "dd/MMMM/yyyy"   /// Medium date format (e.g., 31-December-2023)

    case long = "EEEE, dd MMMM yyyy"  /// Long date format (e.g., Sunday, 31 December 2023)
    case full = "EEEE, dd MMMM yyyy h:mm a"  /// Full date and time format (e.g., Sunday, 31 December 2023 5:30 PM)
}


//Localizable
extension String{
    static let  confirmlLocalizable  = "confirm".localizeString()
    
}

class GenerateQRCodeVC: UIViewController {
    
    let viewtest = viewTest()
    override func loadView() {
        super.loadView()
        
        view = viewtest
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        viewtest.actionDismiss = {
            self.dismiss()
        }
    }
}



extension UIView{
    
    func setupConstraintView(left: CGFloat = 0,
                             right: CGFloat = 0,
                             top: CGFloat = 0,
                             bottom: CGFloat = 0){
        
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: leftAnchor,constant: left),
            self.rightAnchor.constraint(equalTo: rightAnchor,constant: right),
            self.topAnchor.constraint(equalTo: topAnchor,constant: top),
            self.bottomAnchor.constraint(equalTo: bottomAnchor,constant: bottom),
        
        ])
    }
}


class viewTest : UIView{
    
    var actionDismiss: (()->())?
    
    // MARK: - Properties
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .mainColor
        view.clipsToBounds = true
        return view
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // Constants
    private let defaultHeight: CGFloat = 405
    private let dismissibleHeight: CGFloat = 200
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = 405
    
    // Dynamic constraints
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupGestures()
        animatePresentContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupConstraints() {
        addSubview(dimmedView)
        addSubview(containerView)
        
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        // Dynamic constraints2
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Actions
    @objc private func handleCloseAction() {
        animateDismissView()
    }
    
    // MARK: - Gesture Handling
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let newHeight = currentContainerHeight - translation.y
        let isDraggingDown = translation.y > 0
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                self.layoutIfNeeded()
            }
        case .ended:
            handlePanEnd(newHeight: newHeight, isDraggingDown: isDraggingDown)
        default:
            break
        }
    }
    
    private func handlePanEnd(newHeight: CGFloat, isDraggingDown: Bool) {
        if newHeight < dismissibleHeight {
            animateDismissView()
        } else if newHeight < defaultHeight {
            animateContainerHeight(defaultHeight)
        } else if isDraggingDown {
            animateContainerHeight(defaultHeight)
        } else {
            animateContainerHeight(maximumContainerHeight)
        }
    }
    
    // MARK: - Animations
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraint?.constant = height
            self.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.05) {
            self.containerViewBottomConstraint?.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    @objc private func animateDismissView() {
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.layoutIfNeeded()
        } completion: { _ in
            self.actionDismiss?()
        }
    }
}





