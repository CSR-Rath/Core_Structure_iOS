//
//  OneTimeCodeTextField.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 18/9/24.
//

import UIKit

public class OneTimeCodeTextField: UITextField {
    // MARK: UI Components
    public var digitLabels = [UILabel]()
    public var digitLine = [UIView]()

    
    // MARK: Delegates
    public lazy var oneTimeCodeDelegate = OneTimeCodeTextFieldDelegate(oneTimeCodeTextField: self)
    
    // MARK: Properties
    private var isConfigured = false
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    // MARK: Completions
    public var didReceiveCode: ((String) -> Void)?
    
    // MARK: Customisations

    public var codeBackgroundColor: UIColor = .secondarySystemBackground {
        didSet {
            digitLabels.forEach({ $0.backgroundColor = codeBackgroundColor })
        }
    }

    public var codeTextColor: UIColor = .label {
        didSet {
            digitLabels.forEach({ $0.textColor = codeTextColor })
        }
    }
 
    public var codeFont: UIFont = .systemFont(ofSize: 24) {
        didSet {
            digitLabels.forEach({ $0.font = codeFont })
        }
    }
    

    public var codeMinimumScaleFactor: CGFloat = 0.8 {
        didSet {
            digitLabels.forEach({ $0.minimumScaleFactor = codeMinimumScaleFactor })
        }
    }
    
    public var codeCornerRadius: CGFloat = 8 {
        didSet {
            digitLabels.forEach({ $0.layer.cornerRadius = codeCornerRadius })
        }
    }
    
    public var codeCornerCurve: CALayerCornerCurve = .continuous {
        didSet {
            digitLabels.forEach({ $0.layer.cornerCurve = codeCornerCurve })
        }
    }
    
    public var codeBorderWidth: CGFloat = 1 {
        didSet {
            digitLabels.forEach({ $0.layer.borderWidth = codeBorderWidth })
        }
    }
    
    public var codeBorderColor: UIColor? = .lightGray {
        didSet {
            digitLabels.forEach({ $0.layer.borderColor = codeBorderColor?.cgColor })
        }
    }
        
    // MARK: Configuration
    public func configure(withSlotCount slotCount: Int = 6, andSpacing spacing: CGFloat = 8) {
        guard isConfigured == false else { return }
        isConfigured = true
        configureTextField()
        
        let slotsStackView = generateSlotsStackView(with: slotCount, spacing: spacing)
        addSubview(slotsStackView)
        addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            slotsStackView.topAnchor.constraint(equalTo: topAnchor),
            slotsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            slotsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            slotsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        layer.borderWidth = 0
        borderStyle = .none
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = oneTimeCodeDelegate
        
        becomeFirstResponder()
    }
    
}


//MARK: Setup action
extension OneTimeCodeTextField{
    
    //MARK: Setup action on text did change
    @objc private func textDidChange() {
        guard let code = text, code.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]

            
            if i < code.count {
                let index = code.index(code.startIndex, offsetBy: i)
                currentLabel.text = String(code[index]).uppercased()
                currentLabel.layer.borderColor = UIColor.orange.cgColor
                
            } else {
                
                currentLabel.layer.borderColor = codeBorderColor?.cgColor
                currentLabel.text?.removeAll()
            }
        }
        
        if code.count == digitLabels.count { didReceiveCode?(code) }
    }
    
    //MARK: Setup Clear text
    public func clear() {
        guard isConfigured == true else { return }
        digitLabels.forEach({
            $0.text = ""
            $0.layer.borderColor =  codeBorderColor?.cgColor
        })
        
        text = "" // textfield is empty
       
    }
}



//MARK: Setup view OTP
extension OneTimeCodeTextField{
    
    //MARK: Setup box All
    private func generateSlotsStackView(with count: Int, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
        
        for index in 0..<count {
            
            let slotLine = generateSlotLine()
            let slotLabel = generateSlotLabel()
            
            let stack =  setupDigitView(label: slotLabel, lineView: slotLine)
            
            stackView.addArrangedSubview(stack)
            
            //MARK: Check center digit
            if index == count/2-1 {
                stackView.setCustomSpacing(25, after: stack)
            }
            
            digitLabels.append(slotLabel)
            digitLine.append(slotLine)
        }
        
        return stackView
    }
    
    
    //MARK: Setup Stack view Label with line
    private func setupDigitView( label: UILabel, lineView: UIView) -> UIStackView{
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(lineView)
        return stackView
       
    }
    
    //MARK: Setup Label
    private func generateSlotLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = codeFont
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = codeTextColor
        label.backgroundColor = codeBackgroundColor
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = codeCornerRadius
        label.layer.cornerCurve = codeCornerCurve
        
        label.layer.borderWidth = codeBorderWidth
        label.layer.borderColor = codeBorderColor?.cgColor
        
        return label
    }

    //MARK: Setup line
    private func generateSlotLine() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = .orange
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return lineView
    }
    
}
