//
//  LaunchView.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//
import SwiftUI
import UIKit

class LaunchView: UIView {
    
    // MARK: - Properties
    
    private let popCornImage: UIImageView = {
        let image = UIImageView(image: ImageResource.popCornIcon)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let clapperBoard: UIImageView = {
        let image = UIImageView(image: ImageResource.clapperBoard)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let icon: UIImageView = {
        let image = UIImageView(image: ImageResource.movieTime)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .appFontStyle(.title)
        label.textColor = ColorResource.textBlack
        label.text = StringResource.appTitle
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // MARK: - Methods
    
    private func addPopCornImage() {
        self.addSubview(popCornImage)
        popCornImage.translatesAutoresizingMaskIntoConstraints = false
        popCornImage
        .widthEqual(widthAnchor,percent: 0.5)
        .heighEqual(widthAnchor,percent: 0.7)
        .setCenterY(centerYAnchor)
        .leftConstraint(centerXAnchor)
    }
    
    private func addMovieClapper() {
        self.addSubview(clapperBoard)
        let constantSize = 0.4
        clapperBoard
        .translatesAutoresizingMaskIntoConstraints = false
        clapperBoard
        .widthEqual(widthAnchor,percent: constantSize)
        .heighEqual(widthAnchor,percent: constantSize)
        .setCenterY(centerYAnchor,padding: -10)
        .rightConstraint(centerXAnchor)
    }
    
    private func setIcon() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon
        .heighEqual(widthAnchor,percent: 0.2)
        .widthEqual(widthAnchor,percent: 0.2)
    }
    
    private func addTitleSection() {
        let stack = UIStackView(arrangedSubviews: [icon,title])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .horizontal
        self.addSubview(stack)
        setIcon()
        stack
        .bottomConstraint(bottomAnchor,padding: -20)
        .setCenterX(centerXAnchor)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorResource.backgroundColor
        addPopCornImage()
        addMovieClapper()
        addTitleSection()
        clapperBoard.transform = CGAffineTransform(scaleX: 0, y: 0)
        popCornImage.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
}

extension LaunchView {
    
    fileprivate func configAnimation(duration: Double) -> CASpringAnimation {
        let animation = CASpringAnimation(keyPath: "transform")
        animation.duration = duration
        animation.initialVelocity = 0.2
        animation.stiffness = 14
        animation.damping = 5
        return animation
    }
    
    func startLoading(completion: @escaping () -> Void) {
        let duration = 1.7
        
        let animation = configAnimation(duration: duration)
    
        popCornImage.layer.add(animation, forKey: "transform")
        clapperBoard.layer.add(animation, forKey: "transform")
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock { [weak self] in
            
            guard let self = self else {
                return
            }
            
            let grow = CGAffineTransform(scaleX: 1, y: 1)
            let rotate = CGAffineTransform(rotationAngle: .pi / 2 * -0.2)
            self.clapperBoard.transform = grow.concatenating(rotate)
            self.popCornImage.transform = CGAffineTransform(scaleX: 1, y: 1)

        }
        
        CATransaction.commit()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
            completion()
        })
    }
}


