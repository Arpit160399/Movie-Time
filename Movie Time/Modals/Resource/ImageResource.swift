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
}

extension ImageResource {
    private static func getImage(name: String) -> UIImage {
        guard let image = UIImage(named: name) else {
            return  UIImage(systemName: "exclamationmark.triangle.fill") ?? UIImage()
        }
        return image
    }
}
