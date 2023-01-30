//
//  FontHelper.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit

extension UIFont {
    
    enum FontCase {
        case title
        case heading
        case subheading
        case body
    }
    
    static func appFontStyle( _ selected: FontCase) -> UIFont {
        switch selected {
        case .title:
            let selectedFont = UIFont.systemFont(ofSize: 22, weight: .bold)
            let metrics = UIFontMetrics(forTextStyle: .largeTitle)
            return metrics.scaledFont(for: selectedFont)
        case .heading:
            let selectedFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
            let metrics = UIFontMetrics(forTextStyle: .headline)
            return metrics.scaledFont(for: selectedFont)
        case .subheading:
            let selectedFont = UIFont.systemFont(ofSize: 15, weight: .medium)
            let metrics = UIFontMetrics(forTextStyle: .subheadline)
            return metrics.scaledFont(for: selectedFont)
        case .body:
            let selectedFont = UIFont.systemFont(ofSize: 15, weight: .medium)
            let metrics = UIFontMetrics(forTextStyle: .body)
            return metrics.scaledFont(for: selectedFont)
        }
    }
        
}
