//
//  ColorResource.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import Foundation
import UIKit

public enum ColorResource {
    
    static var backgroundColor: UIColor { getColor(name: "background") }
    static var appYellow: UIColor { getColor(name: "AppYellow") }
    static var appBlack: UIColor { getColor(name: "default") }
    static var appWhite: UIColor { getColor(name: "appWhite") }
    static var primaryColor: UIColor { getColor(name: "ActiveColor") }
    static var secondaryColor: UIColor { getColor(name: "Secondary") }
    static var bodyTextColor: UIColor { getColor(name: "TextColorLevel2") }
    static var subHeadingTextColor: UIColor { getColor(name: "TextColorLevel2") }
}

extension ColorResource {
    private static func getColor(name: String) -> UIColor {
        guard let colour = UIColor(named: name) else {
            return  .white
        }
        return colour
    }
}
