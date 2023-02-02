//
//  OnboardingView.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit
import Combine

class OnBoardingView: UIView {
    // MARK: - Properties
    
    // UI Elements
    private let emailField: UIInputTextField = {
        let email = UIInputTextField(.email)
        return email
    }()
    
    private let nameField: UIInputTextField = {
        let name = UIInputTextField(.name)
        return name
    }()
    
    private let passwordField: UIInputTextField = {
        let password = UIInputTextField(.password)
        return password
    }()
    
    private let actionButton: ActiveButton = {
        let activeButton = ActiveButton()
        activeButton.setTitle(StringResource.signInButton)
        activeButton.setIcon(ImageResource.arrowLeft)
        return activeButton
    }()
    
    private let banner: UIImageView = {
        let banner = UIImageView()
        banner.image = ImageResource.signInBannerImage
        banner.contentMode = .scaleAspectFit
        return banner
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFontStyle(.title)
        label.textColor = ColorResource.appBlack
        label.textAlignment = .center
        label.text = StringResource.signInTitle
        return label
    }()
    
    private let moveTo: UIButton = {
        let button = UIButton()
        let attributes = [NSAttributedString.Key.font: UIFont.appFontStyle(.subheading),
                          NSAttributedString.Key.underlineStyle: 1,
                          NSAttributedString.Key.foregroundColor: ColorResource.subHeadingTextColor]
        button.setAttributedTitle(.init(string: StringResource.navigationToSignUp,
                            attributes: attributes), for: .normal)
        return button
    }()
    
    private let padding: CGFloat = 15
    private let interFiledSpacing: CGFloat = 40
    private let height: CGFloat = 40
    private let scrollView: UIScrollView = .init()
    private var activeTextField: UITextField?
    private var emailTopConstraint: NSLayoutConstraint?
    private let subject = PassthroughSubject<OnBoardValuePublisher,Never>()
    
    public var currentCase: OnBoardingCase = .login {
        didSet {
            changeView()
        }
    }
    
    // setting value publisher
    public func getValuePublisher() -> AnyPublisher<OnBoardValuePublisher,Never> {
        return subject.eraseToAnyPublisher()
    }
    
    // UI Contrastes setup
    fileprivate func setupScrollView() {
        scrollView.pinToParent(view: self)
        scrollView.backgroundColor = ColorResource.backgroundColor
        backgroundColor = ColorResource.backgroundColor
    }
    
    fileprivate func setupBannerImage() {
        scrollView.addSubview(banner)
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.topConstraint(scrollView.topAnchor, padding: padding * 4)
            .leftConstraint(scrollView.leftAnchor, padding: padding)
            .rightConstraint(scrollView.rightAnchor, padding: padding)
            .heighEqual(heightAnchor, percent: 0.2)
    }
    
    fileprivate func setupTitle() {
        scrollView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topConstraint(banner.bottomAnchor, padding: padding * 2)
            .leftConstraint(scrollView.leftAnchor, padding: padding)
            .rightConstraint(scrollView.rightAnchor, padding: padding)
    }
    
    fileprivate func setupName() {
        scrollView.addSubview(nameField)
        nameField.setTextFieldDelegate(self)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.leftConstraint(scrollView.leftAnchor, padding: padding)
            .rightConstraint(scrollView.rightAnchor, padding: padding)
            .topConstraint(titleLabel.bottomAnchor, padding: interFiledSpacing)
            .setHeight(height)
        nameField.isHidden = true
    }
    
    fileprivate func setupEmail() {
        scrollView.addSubview(emailField)
        emailField.setTextFieldDelegate(self)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.leftConstraint(scrollView.leftAnchor, padding: padding)
            .rightConstraint(scrollView.rightAnchor, padding: padding)
            .widthEqual(widthAnchor, percent: 0.9)
            .setHeight(height)
        emailTopConstraint = emailField.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor,
                        constant: interFiledSpacing)
        emailTopConstraint?.isActive = true
    }
 
    fileprivate func setupPassword() {
        scrollView.addSubview(passwordField)
        passwordField.setTextFieldDelegate(self)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.topConstraint(emailField.bottomAnchor, padding: interFiledSpacing)
            .leftConstraint(scrollView.leftAnchor, padding: padding)
            .rightConstraint(scrollView.rightAnchor, padding: padding)
            .setHeight(height)
    }
    
    fileprivate func setupNavigationButton() {
        scrollView.addSubview(moveTo)
        moveTo.translatesAutoresizingMaskIntoConstraints = false
        moveTo.topConstraint(passwordField.bottomAnchor, padding: padding)
            .leftConstraint(scrollView.leftAnchor, padding: padding * 1.4)
        moveTo.addAction(UIAction(handler: { _ in
            if self.currentCase == .signUp {
                self.currentCase = .login
            } else {
                self.currentCase = .signUp
            }
        }), for: .touchUpInside)
    }
    
    fileprivate func setupActionButton() {
        scrollView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.topConstraint(moveTo.bottomAnchor, padding: interFiledSpacing)
            .leftConstraint(scrollView.leftAnchor, padding: padding)
            .rightConstraint(scrollView.rightAnchor, padding: padding)
            .bottomConstraint(scrollView.bottomAnchor, padding: -padding)
            .setHeight(55)
        actionButton.addAction(.init(handler: { _ in
            self.sendValue()
        }), for: .touchUpInside)
    }
    
    fileprivate func activateKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupInputFields() {
        setupTitle()
        setupName()
        setupEmail()
        setupPassword()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
        setupBannerImage()
        setupInputFields()
        setupNavigationButton()
        setupActionButton()
        activateKeyboardNotification()
    }
    // Setting button action
    private func sendValue() {
        actionButton.startLoading()
        switch currentCase {
        case .login:
            let auth = UserAuth(userEmail: emailField.getText() ?? "",
                                password: passwordField.getText() ?? "")
            subject.send(.login(auth))
        case .signUp:
            let register = RegisterUser(name: nameField.getText() ?? "",
                                        email: emailField.getText() ?? "",
                                        password: passwordField.getText() ?? "")
            subject.send(.signUp(register))
        }
    }
    
    public func processComplete() {
        actionButton.stopLoading()
    }
    
    public func setErrorTo(_ field: OnBoardField) {
        switch field {
        case .name:
            nameField.setToErrorState()
        case .email:
            emailField.setToErrorState()
        case .password:
            passwordField.setToErrorState()
        }
       processComplete()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Changing view layout by cases

private extension OnBoardingView {
    func changeView() {
        changeLayout()
         let attributes = [NSAttributedString.Key.font: UIFont.appFontStyle(.subheading),
                           NSAttributedString.Key.underlineStyle: 1,
                           NSAttributedString.Key.foregroundColor: ColorResource.subHeadingTextColor] as [NSAttributedString.Key: Any]
      
        UIView.animate(withDuration: 0.6, delay: 0) {
            self.layoutIfNeeded()
            self.titleLabel.alpha = 0
            self.banner.alpha = 0
            self.moveTo.alpha = 0
            self.titleLabel.text = self.currentCase.title
            self.moveTo.setAttributedTitle(.init(string: self.currentCase.buttonTitle,
                                            attributes: attributes), for: .normal)
            self.actionButton.setTitle(self.currentCase.actionButtonTitle)
            self.banner.image = self.currentCase.imageBanner
            self.titleLabel.alpha = 1
            self.banner.alpha = 1
            self.moveTo.alpha = 1
        }
    }
    
    func changeLayout() {
        emailTopConstraint?.isActive = false
        switch currentCase {
            case .login:
            emailTopConstraint = emailField.topAnchor
                .constraint(equalTo: titleLabel.bottomAnchor,
                            constant: interFiledSpacing)
            case .signUp:
            emailTopConstraint = emailField.topAnchor
                .constraint(equalTo: nameField.bottomAnchor,
                            constant: interFiledSpacing)
        }
        emailTopConstraint?.isActive = true
        self.nameField.isHidden = !self.nameField.isHidden
    }
}

// MARK: - KeyBoard mangament

extension OnBoardingView: UITextFieldDelegate {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboard = keyboardSize.cgRectValue
        guard let tf = activeTextField else { return }
        let constentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboard.height, right: 0)
        scrollView.contentInset = constentInset
        scrollView.scrollIndicatorInsets = constentInset
        var aRect: CGRect = frame
        aRect.size.height -= (keyboard.height)
        let activeTextFieldRect = tf.frame
        let activeTextFieldOrigin = CGPoint(x: activeTextFieldRect.origin.x, y: activeTextFieldRect.origin.y + height)
        if !aRect.contains(activeTextFieldOrigin) {
            scrollView.scrollRectToVisible(activeTextFieldRect, animated: true)
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { self.layoutIfNeeded() }) { _ in
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let constentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = constentInset
        scrollView.scrollIndicatorInsets = constentInset
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: { self.layoutIfNeeded() }) { _ in
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
