//
//  TageView.swift
//  Movie Time
//
//  Created by Arpit Singh on 31/01/23.
//

import UIKit
class TagView: UIView {
     
    private let label: UILabel = {
        let label = UILabel()
        label.font = .appFontStyle(.subheading)
        label.textColor = ColorResource.appBlack
        label.textAlignment = .center
        return label
    }()
    
    private let horizontalPadding: CGFloat = 10
    private let verticalPadding: CGFloat = 5

    fileprivate func setupLabel() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.topConstraint(topAnchor,padding: verticalPadding)
            .bottomConstraint(bottomAnchor,padding: -verticalPadding)
            .leftConstraint(leftAnchor,padding: horizontalPadding)
            .rightConstraint(rightAnchor,padding: -horizontalPadding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 3
        layer.borderColor = ColorResource.appBlack.cgColor
        setupLabel()
    }
    
    public func set(title: String) {
        label.text = title
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = rect.height / 2
        layer.masksToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
