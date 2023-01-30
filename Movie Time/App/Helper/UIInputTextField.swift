//
//  UIInputTextField.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit

class UIInputTextField: UIView {
    
    enum InputType: String {
        case name
        case email
        case password
        case phoneNumber
    }
    // MARK: - Properties
    
    private var inputType: InputType = .password
    private var comicView = ComicCard()
    private var textField = UITextField()
    private let icon = UIImageView()
    private let button = UIButton()
    private let padding: CGFloat = 10
    
    // MARK: - Methods
    
    convenience init(_ type: InputType) {
        self.init(frame: .zero,type)
    }

    init(frame: CGRect,_ type: InputType) {
        super.init(frame: frame)
        self.inputType = type
        startViewSetUP()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        startViewSetUP()
    }
    
    fileprivate func startViewSetUP() {
        comicView.pinToParent(view: self)
        setLeftIcon()
        addTextFiled()
        setUpFiledInfo()
    }
        
    private func setLeftIcon() {
        if inputType == .password {
            addButton()
            addButtonAction()
        } else {
            addIcon()
        }
    }
    
    public func getText() -> String? {
        return textField.text
    }
    
    public func setTextFieldDelegate(_ instance:  UITextFieldDelegate) {
        textField.delegate = instance
    }
    
    public func setToErrorState()  {
        UIView.animate(withDuration: 0.8, delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.4, animations: {
            self.comicView.transform = .init(translationX: -7, y: 0)
            self.comicView.borderColor = UIColor.red.cgColor
            self.comicView.transform = .init(translationX: 6, y: 0)
        }, completion: { _ in
            self.comicView.borderColor = ColorResource.appBlack.cgColor
            self.comicView.transform = .init(translationX: 0, y: 0)
        })
    }
    
    private func addButton() {
        button.tintColor = ColorResource.appBlack
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button
        .rightConstraint(comicView.contentView.rightAnchor,padding: -padding)
        .topConstraint(comicView.contentView.topAnchor,padding: padding)
        .bottomConstraint(comicView.contentView.bottomAnchor,padding: -padding)
        .widthEqual(heightAnchor,percent: 0.8)
    }
    
    private func addIcon() {
        icon.contentMode = .scaleAspectFit
        icon.tintColor = ColorResource.appBlack
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon
        .rightConstraint(comicView.contentView.rightAnchor,padding: -padding)
        .topConstraint(comicView.contentView.topAnchor,padding: padding)
        .bottomConstraint(comicView.contentView.bottomAnchor,padding: -padding)
        .widthEqual(heightAnchor,percent: 0.8)
    }
    
    private func addTextFiled() {
        comicView.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.adjustsFontForContentSizeCategory = true
        textField.font = .appFontStyle(.subheading)
        textField.textColor = ColorResource.appBlack
        textField
        .leftConstraint(comicView.contentView.leftAnchor,padding: padding + 5)
        .topConstraint(comicView.contentView.topAnchor,padding: padding)
        .bottomConstraint(comicView.contentView.bottomAnchor,padding: -padding)
        textField.inputAccessoryView = toolBar()
    }
    
    private func toolBar() -> UIToolbar {
        let width = UIScreen.main.bounds.width
        let toolBarView = UIToolbar(frame: .init(x: 0, y: 0, width: width,
                                                 height: 40))
        toolBarView.setItems([UIBarButtonItem(barButtonSystemItem: .done,
        target: self, action: #selector(dismissInput))], animated: false)
        return toolBarView
    }

    @objc func dismissInput() {
        textField.resignFirstResponder()
    }
            
    private func setUpFiledInfo() {
        switch inputType {
            case .name:
            textField.rightConstraint(icon.leftAnchor,padding: padding)
            icon.image = ImageResource.personIcon
            textField.textContentType = .name
            case .email:
            icon.image = ImageResource.emailIcon
            textField.rightConstraint(icon.leftAnchor,padding: padding)
            textField.textContentType = .emailAddress
            case .password:
            textField.isSecureTextEntry = true
            button.setImage(ImageResource.closedEyeIcon, for: .normal)
            textField.rightConstraint(button.leftAnchor,padding: padding)
            textField.textContentType = .password
            case .phoneNumber:
            icon.image = ImageResource.personIcon
            textField.rightConstraint(icon.leftAnchor,padding: padding)
            textField.textContentType = .telephoneNumber
      }
        textField.attributedPlaceholder = NSAttributedString(string: inputType.rawValue,attributes:  [NSAttributedString.Key.foregroundColor : ColorResource.subHeadingTextColor])
    }
    
    fileprivate func addButtonAction() {
        button.addAction(UIAction(handler: { [weak self ]action in
            guard let self = self else { return }
            if self.textField.isSecureTextEntry {
                self.textField.isSecureTextEntry = false
                self.button.setImage(ImageResource.openEyeIcon, for: .normal)
            } else {
                self.textField.isSecureTextEntry = true
                self.button.setImage(ImageResource.closedEyeIcon, for: .normal)
            }
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


