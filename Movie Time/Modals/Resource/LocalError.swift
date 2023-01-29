//
//  LocalError.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
protocol LocalError: Error {
    var localizedDescription: String { get }
}
