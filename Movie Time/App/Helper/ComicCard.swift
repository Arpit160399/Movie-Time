//
//  ComicCard.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit
class ComicCard: UIView {
    
    // MARK: - Properties
    
    var radius: CGFloat = 20 {
        didSet {
            contentView.layer.cornerRadius = radius
        }
    }
    
    var borderColor: CGColor = ColorResource.appBlack.cgColor {
        didSet {
            contentView.layer.borderColor = borderColor
        }
    }
    
    var shadowColor: UIColor = ColorResource.appBlack {
        didSet {
            shadowView.backgroundColor = shadowColor
        }
    }
    
    lazy var contentView: UIView = UIView()
    
    private lazy var shadowView = UIView()
    private let shadowHeight: CGFloat = 7
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addContentView()
        addComicShadow()
    }
    
    private func addContentView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView
            .leftConstraint(leftAnchor)
            .topConstraint(topAnchor)
            .bottomConstraint(bottomAnchor,padding: shadowHeight)
            .rightConstraint(rightAnchor,padding: -shadowHeight)
        contentView.backgroundColor = ColorResource.appWhite
        contentView.layer.borderWidth = 4
        contentView.layer.cornerRadius = radius
        contentView.layer.borderColor = borderColor
    }
    
    private func addComicShadow() {
        addSubview(shadowView)
        shadowView.layer.cornerRadius = radius
        shadowView.backgroundColor = shadowColor
        self.sendSubviewToBack(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView
            .heighEqual(contentView.heightAnchor,percent: 0.75)
            .widthEqual(contentView.widthAnchor)
            .bottomConstraint(contentView.bottomAnchor,
                              padding: shadowHeight)
            .leftConstraint(contentView.leftAnchor,padding: shadowHeight)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let currentRadius = contentView.layer.cornerRadius
        shadowView.layer.cornerRadius = currentRadius
    }
    
}
