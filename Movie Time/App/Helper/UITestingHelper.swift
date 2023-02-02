//
//  UITestingHelper.swift
//  Movie Time
//
//  Created by Arpit Singh on 02/02/23.
//

import UIKit
enum UITesting: String {
    case Login
    
    var controller: UIViewController {
        switch self {
        case .Login:
            return MainAppDependencyContainer().makeOnBoardingViewController()
        }
    }

}
