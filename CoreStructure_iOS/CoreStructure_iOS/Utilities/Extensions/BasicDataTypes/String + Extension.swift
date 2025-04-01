//
//  String.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation
import UIKit


//MARK: ==================== Handle localize ====================

func setLanguage(langCode: LanguageTypeEnum) {
    UserDefaults.standard.setValue(langCode.rawValue, forKey: KeyUser.language)
}

func getLanguageType() -> String{
    return UserDefaults.standard.string(forKey: KeyUser.language) ?? "en"
}

extension String {
    
  
}
//
//    func localizeString() -> String {
//        let lang = UserDefaults.standard.string(forKey: KeyUser.language)
//        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//        let bundle = Bundle(path: path!)
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
//    
//}

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



//Localizable
extension String{
   
    static let  confirmlLocalizable  = "confirm".localizeString()
    
}

class GenerateQRCodeVC: UIViewController {
    
    let viewtest = TermAndConditionRoyaltyView()
    
    override func loadView() {
        super.loadView()
        view = viewtest
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        viewtest.actionDismiss = {
            self.dismiss(animated: true)   
        }
    }
}


class TermAndConditionRoyaltyView: UIView {
    
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
    private let defaultHeight: CGFloat = 600
    private let dismissibleHeight: CGFloat = 600/2
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = 600
    
    // Dynamic constraints
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    
    lazy var viewLineTop: UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var lblName: UILabel = {
        let lbl  = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "terms_and_conditions"
        lbl.textColor = .white
        lbl.fontBold(16)
        return lbl
    }()
    
    
    lazy var descriptionLbl: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.backgroundColor = .clear//.mainColor
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        return textView
    }()
    
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
        
        // Dynamic constraints
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        containerView.addSubviews(of: viewLineTop, lblName, descriptionLbl)
        
        NSLayoutConstraint.activate([
            
            viewLineTop.heightAnchor.constraint(equalToConstant: 2),
            viewLineTop.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            viewLineTop.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 13),
            viewLineTop.widthAnchor.constraint(equalToConstant: 85),
            
            lblName.centerXAnchor.constraint(equalTo: containerView .centerXAnchor),
            lblName.topAnchor.constraint(equalTo: viewLineTop.bottomAnchor,constant: 24),
            
            descriptionLbl.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 25),
            descriptionLbl.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: 25),
            descriptionLbl.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 50),
            descriptionLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 0),
            
        ])
        
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




