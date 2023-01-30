//
//  OnBoardingCase.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit
enum OnBoardingCase {
    case login
    case signUp
    
    var title: String {
        switch self {
            case .login:
                return StringResource.signInTitle
            case .signUp:
                return StringResource.signUpTitle
        }
    }
    
    var imageBanner: UIImage {
        switch self {
            case .login:
                return ImageResource.signInBannerImage
            case .signUp:
                return ImageResource.signUpBannerImage
        }
    }
    
    var actionButtonTitle: String {
        switch self {
            case .login:
                return StringResource.signInButton
            case .signUp:
                return StringResource.signUpButton
        }
    }
    
    var buttonTitle: String {
        switch self {
            case .signUp:
                return StringResource.navigationToSignIn
            case .login:
                return StringResource.navigationToSignUp
        }
    }
}


