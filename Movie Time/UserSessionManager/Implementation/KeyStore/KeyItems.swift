//
//  KeyItem.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//
import Foundation
import LocalAuthentication

class KeyItem {
    
    // MARK: - Properties
    public let service: NSString = "Movie.Time.service"
    public let itemClass = kSecClass as String
    public let itemService = kSecAttrService as String
    public let itemAccessControl = kSecAttrAccessControl as String
    public var access = SecAccessControlCreateWithFlags(nil, // Use the default allocator.
                                                 kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                 .userPresence,
                                                 nil) // Ignore any error.
    
    // MARK: - Methods
    
    func getItems() -> CFDictionary {
        let item: [String: Any] = [itemClass: kSecClassGenericPassword,
                                         itemAccessControl: access as Any,
                                         itemService: service]
        return item as CFDictionary
    }
    
}

