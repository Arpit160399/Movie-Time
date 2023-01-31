//
//  ImageResource.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
import UIKit

 public enum ImageResource {
    
     static var popCornIcon: UIImage { getImage(name: "PopCorn") }
     static var movieTime: UIImage { getImage(name: "MovieTime")}
     static var clapperBoard: UIImage { getImage(name: "ClapperBoard") }
     static var arrowLeft: UIImage { UIImage(systemName: "chevron.right") ?? UIImage() }
     static var personIcon: UIImage { UIImage(systemName: "person.fill") ?? UIImage() }
     static var emailIcon: UIImage { UIImage(systemName: "at.circle") ?? UIImage() }
     static var openEyeIcon: UIImage { UIImage(systemName: "eye.fill") ?? UIImage() }
     static var closedEyeIcon: UIImage { UIImage(systemName: "eye.slash.fill") ?? UIImage() }
     static var phoneNumber: UIImage { UIImage(systemName: "phone.fill") ?? UIImage() }
     static var signInBannerImage: UIImage { getImage(name: "SignInBannerImage") }
     static var signUpBannerImage: UIImage { getImage(name: "SignUpBannerImage") }
     static var logoutIcon: UIImage { UIImage(systemName: "person.crop.circle.fill.badge.minus") ?? UIImage() }
}

extension ImageResource {
    private static func getImage(name: String) -> UIImage {
        guard let image = UIImage(named: name) else {
            return  UIImage(systemName: "exclamationmark.triangle.fill") ?? UIImage()
        }
        return image
    }
}
