//
//  ConstraintHelper.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import UIKit
extension UIView {
    
    func pinToParent(view: UIView,padding: CGFloat = 0) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor,constant: padding),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -padding),
            self.leftAnchor.constraint(equalTo: view.leftAnchor,constant: padding),
            self.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -padding)
        ])
    }
    
    
    @discardableResult
    func leftConstraint(_ pinTo: NSLayoutXAxisAnchor,padding: CGFloat = 0) -> UIView {
        self.leftAnchor.constraint(equalTo: pinTo , constant: padding)
            .isActive = true
        return self
    }
    
    @discardableResult
    func rightConstraint(_ pinTo: NSLayoutXAxisAnchor,padding: CGFloat = 0) -> UIView {
        self.rightAnchor.constraint(equalTo: pinTo, constant: padding)
            .isActive = true
        return self
    }
    
    @discardableResult
    func topConstraint(_ pinTo: NSLayoutYAxisAnchor,padding: CGFloat = 0) -> UIView {
        self.topAnchor.constraint(equalTo: pinTo, constant: padding)
            .isActive = true
        return self
    }
    
    @discardableResult
    func bottomConstraint(_ pinTo: NSLayoutYAxisAnchor,padding: CGFloat = 0) -> UIView {
        self.bottomAnchor.constraint(equalTo: pinTo, constant: padding)
            .isActive = true
        return self
    }
    
    @discardableResult
    func setCenterX(_ pinTo: NSLayoutXAxisAnchor,padding: CGFloat = 0) -> UIView {
        self.centerXAnchor.constraint(equalTo: pinTo,constant: padding).isActive = true
        return self
    }
    
    @discardableResult
    func setCenterY(_ pinTo: NSLayoutYAxisAnchor,padding: CGFloat = 0) -> UIView {
        self.centerYAnchor.constraint(equalTo: pinTo,constant: padding).isActive = true
        return self
    }
    
    @discardableResult
    func setHeight(_ constant: CGFloat) -> UIView {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }

    @discardableResult
    func setWidth(_ constant: CGFloat) -> UIView {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }

    @discardableResult
    func widthEqual(_ pinTo: NSLayoutDimension,percent: CGFloat = 1) -> UIView {
        self.widthAnchor.constraint(equalTo: pinTo, multiplier: percent)
            .isActive = true
        return self
    }

    @discardableResult
    func heighEqual(_ pinTo: NSLayoutDimension,percent: CGFloat = 1) -> UIView {
        self.heightAnchor.constraint(equalTo: pinTo, multiplier: percent)
            .isActive = true
        return self
    }

}
