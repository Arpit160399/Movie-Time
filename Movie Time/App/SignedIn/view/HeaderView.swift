//
//  HeaderView.swift
//  Movie Time
//
//  Created by Arpit Singh on 31/01/23.
//

import UIKit

class HeaderView: UIView {

    private let comicView = ComicCard()
    
    private let heading: UILabel = {
        let label = UILabel()
        label.textColor = ColorResource.appWhite
        label.font = .appFontStyle(.title)
        label.textAlignment = .left
        return label
    }()
    
    private let subHeading: UILabel = {
        let label = UILabel()
        label.textColor = ColorResource.appWhite
        label.font = .appFontStyle(.subheading)
        label.text = StringResource.userMessage
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let padding: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comicView.pinToParent(view: self,padding: 5)
        comicView.contentView.backgroundColor = ColorResource.primaryColor
        setupHeadingView()
        setupSubHeadingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupHeadingView() {
        comicView.contentView.addSubview(heading)
        heading.translatesAutoresizingMaskIntoConstraints = false
        heading.leftConstraint(comicView.contentView.leftAnchor,padding: padding)
            .rightConstraint(comicView.contentView.rightAnchor,padding: -padding)
            .topConstraint(comicView.contentView.topAnchor,padding: padding)
    }
    
    fileprivate func setupSubHeadingView() {
        comicView.contentView.addSubview(subHeading)
        subHeading.translatesAutoresizingMaskIntoConstraints = false
        subHeading.leftConstraint(comicView.contentView.leftAnchor,padding: padding)
            .rightConstraint(comicView.contentView.rightAnchor,padding: -padding)
            .bottomConstraint(comicView.contentView.bottomAnchor,padding: -padding)
        
        subHeading.topAnchor.constraint(greaterThanOrEqualTo: heading.bottomAnchor,constant: padding).isActive = true
    }
    
    func setGetting(_ name: String) {
        heading.text = StringResource.getWelcomeMessage(name)
    }
}
