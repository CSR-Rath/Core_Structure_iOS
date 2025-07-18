import UIKit

enum StatusTextField{
    case editingDidBegin
    case editingChanged
    case editingDidEnd
}

class FloatingLabelTextField: UITextField, UITextFieldDelegate {
    
    private var statusTextField: StatusTextField = .editingDidEnd
    private var isEditingDidBegin: Bool = false
    private var isRequired: Bool = false
    
    var isOptionalField: Bool = false
    var didEditingDidBegin:(()->())?
    var didEditingChanged:(()->())?
    
    var  didEditingDidEnd:(()->())?
    
    override var backgroundColor: UIColor?{
        didSet{
            label.backgroundColor = backgroundColor
        }
    }
    
    
    // MARK: - Handle title color
    var title: String = "" {
        didSet{
            
            if isRequired{
                
                let last = " *"
                
                let fullText = title + last
                
                let rangesAndColors: [(NSRange, UIColor)] = [
                    (NSRange(location: 0, length: title.count ), .black),
                    (NSRange(location: title.count, length: 2), .red),
                ]
                
                label.setAttributedTextWithColors(text: fullText,
                                                  rangesAndColors: rangesAndColors)
                
            }else{
                label.text = title
            }
        }
    }
    
    var titleColor: UIColor = .black {
        didSet{
            label.textColor = titleColor
        }
    }
    
    var isValidate: Bool = false {
        didSet{
            if isValidate {
                
                if statusTextField == .editingDidBegin{
                    borderView.layer.borderColor = UIColor.orange.cgColor
                }else if statusTextField == .editingChanged{
                    borderView.layer.borderColor = UIColor.mainBlueColor.cgColor
                }else if statusTextField == .editingDidEnd{
                    borderView.layer.borderColor = UIColor.orange.cgColor
                }
                
            }else{
               
                borderView.layer.borderColor = UIColor.red.cgColor
            }
            
            stackError.isHidden = isValidate
        }
    }
    
    private let label: BaseUILabelPadding = {
        let label = BaseUILabelPadding()
        label.font = UIFont.appFont(style: .bold, size: 14)
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "Title"
        label.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconErrorImg: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.red // Ensure opaque
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let validateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Field is required!"
        label.fontRegular(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackError: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = UIColor.clear // Ensure opaque
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        stack.isHidden = true
        return stack
    }()
    
    
    private let maskViews: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white // Ensure opaque
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let iconRightImg: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear // Ensure opaque
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if text == "" && isEditingDidBegin == false{
            UIView.animate(withDuration: 0.2) { [self] in
                label.alpha = 0.5
                iconRightImg.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } completion: { [self] _ in
                label.alpha = 1
                iconRightImg.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
        self.becomeFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if text != ""{
            animateFloatingLabel(to: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("NSCoder")
    }
    
}

enum TextFieldIconRigth{
    case iconDdate
    case iconCircle
    case iconDropDown
    case iconEmpty
}

// MARK: - Handle TextField element change
extension FloatingLabelTextField{
    
    func isRequiredStar(){
        isRequired = true
    }
    
    func isOptionalTextField(){
        isOptionalField = true
    }
    
    
    func changeIconRight(icon : TextFieldIconRigth){
        
        switch icon{
        case .iconDdate:
            
//            iconRightImg.image = .icNextWhite
            isPadding(left: 12, right: 40)
            
        case .iconCircle:
            
//            iconRightImg.image = .icNextWhite
            isPadding(left: 12, right: 40)
            
        case .iconDropDown:
            
            isPadding(left: 12, right: 40)
//            iconRightImg.image = .icNextWhite
            
        case .iconEmpty:
            
            isPadding(left: 12, right: 12)
            iconRightImg.isHidden = true
            
        }
    }
}

// MARK: - Action textfield
extension FloatingLabelTextField{
    
    @objc private func editingDidBegin() {
        
        stackError.isHidden = true
        isEditingDidBegin = true
        
        didEditingDidBegin?()
        
        statusTextField = .editingDidBegin
        borderView.layer.borderColor = UIColor.mainBlueColor.cgColor
        borderView.layer.borderWidth = 2
        
        animateFloatingLabel(to: 1)
    }
    
    @objc private func editingChanged(){
        
        statusTextField = .editingChanged
        borderView.layer.borderColor = UIColor.mainBlueColor.cgColor
        borderView.layer.borderWidth = 2
        
        didEditingChanged?()
        
    }
    
    @objc private func editingDidEnd() {
        isEditingDidBegin = false
        
        statusTextField = .editingDidEnd
        
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 1.5
        
        
        if text?.isEmpty == true {
            UIView.animate(withDuration: 0.2) {
                self.label.transform = .identity
            }
        }
    }
    
    private func animateFloatingLabel(to alpha: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.label.alpha = alpha
            self.label.transform = alpha == 1 ? CGAffineTransform(translationX: 0, y: -25) : .identity
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if let  text = textField.text{
            let dotCount = text.filter { $0 == "." }.count
            let commaCount = text.filter { $0 == "," }.count
            
            print("dotCount: \(dotCount) \n comaCount: \(commaCount)")
            
            if dotCount + commaCount > 1{
                textField.text?.removeLast()
            }
//            textFieldDidChangeSelection?(text)
        }
        
    }
    
}

// MARK: - Setup layoutConstraint
extension FloatingLabelTextField{
    
    private func setupUI() {
      
        let fullView = UIView(frame: self.bounds)
        fullView.backgroundColor = .orange.withAlphaComponent(0.1)
        addSubview(fullView)
        
        //==========//====== Hendle self
        isPadding(left: 12, right: 12)

        heightAnchor.constraint(equalToConstant: 70).isActive = true
        //==========//======
        
        addSubview(borderView)
        addSubview(label)
        
        addSubview(iconRightImg)
        
        addSubview(stackError)
        stackError.addArrangedSubview(iconErrorImg)
        stackError.addArrangedSubview(validateLabel)
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            
            borderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 50),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackError.topAnchor.constraint(equalTo: self.bottomAnchor),
            stackError.leftAnchor.constraint(equalTo: borderView.leftAnchor),
            stackError.rightAnchor.constraint(equalTo: borderView.rightAnchor),
            
            iconErrorImg.heightAnchor.constraint(equalToConstant: 20),
            iconErrorImg.widthAnchor.constraint(equalToConstant: 20),
            
            iconRightImg.heightAnchor.constraint(equalToConstant: 20),
            iconRightImg.widthAnchor.constraint(equalToConstant: 20),
            iconRightImg.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconRightImg.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
        ])
        
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
}

// MARK: - Handle Array FloatingLabelTextField
extension UIView{
    
    func arrayTextFieldsResignFirstResponder(textFields: [FloatingLabelTextField]){
        
        textFields.forEach({ item in
            item.resignFirstResponder()
        })
        
    }
    
    func isValidateTextField(textFields: [FloatingLabelTextField],
                             success : @escaping (_ success: FloatingLabelTextField)->(),
                             failure : @escaping (_ failure: FloatingLabelTextField)->()
    ){
        
        textFields.forEach({ item in
            
            if (item.text == "" || item.text == "  ") && item.isOptionalField == false{
                
                item.isValidate = false
                failure(item)
                
            }else{
                
                success(item)
                item.isValidate = true
                
                
            }
        })
    }
}

// MARK: - Setup AttributedString Colors
extension UILabel {
    func setAttributedTextWithColors(text: String, rangesAndColors: [(range: NSRange, color: UIColor)]) {
        let attributedString = NSMutableAttributedString(string: text)
        
        for rangeAndColor in rangesAndColors {
            attributedString.addAttribute(.foregroundColor, value: rangeAndColor.color, range: rangeAndColor.range)
        }
        
        self.attributedText = attributedString
    }
}



