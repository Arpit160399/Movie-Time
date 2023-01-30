//
//  ActiveButton.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit

class ActiveButton: UIButton {

    private let comicCard = ComicCard()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .appFontStyle(.heading)
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.text = "tmep"
        return label
    }()
    
    private let icon: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.image?.applyingSymbolConfiguration(.init(scale: .large))
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comicCard.radius = 5
        comicCard.pinToParent(view: self)
        comicCard.contentView.backgroundColor = ColorResource.primaryColor
        comicCard.isUserInteractionEnabled = false
        setupView()
        setupIcon()
        setActivityIndictor()

    }
    
    private func setupView() {
        comicCard.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topConstraint(comicCard.contentView.topAnchor)
            .bottomConstraint(comicCard.contentView.bottomAnchor)
        .setCenterX(comicCard.contentView.centerXAnchor)
    }
    
    private func setActivityIndictor() {
        comicCard.contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.setHeight(30).setWidth(30)
            .setCenterX(comicCard.contentView.centerXAnchor)
            .setCenterY(comicCard.contentView.centerYAnchor)
        activityIndicator.tintColor = ColorResource.appBlack
        activityIndicator.color = ColorResource.appBlack
        activityIndicator.isHidden = true
    }
    
    private func setupIcon() {
        let padding: CGFloat = 10
        comicCard.contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.topConstraint(comicCard.contentView.topAnchor,padding: padding)
            .bottomConstraint(comicCard.contentView.bottomAnchor,padding: -padding)
            .leftConstraint(label.rightAnchor,padding: padding)
//            .widthEqual(comicCard.contentView.widthAnchor,percent: 0.5)
    }
    
    public func startLoading() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.label.isHidden = true
        self.icon.isHidden = true
    }
    
    public func stopLoading() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.label.isHidden = false
        self.icon.isHidden = false
    }
    
    public func setIcon(_ image: UIImage) {
        icon.image = image
    }
    
    public func setTitle(_ text: String) {
        label.text = text
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


import SwiftUI
struct ViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        return ActiveButton()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable()
            .frame(width: 350)
            .frame(height: 50)
    }
}
