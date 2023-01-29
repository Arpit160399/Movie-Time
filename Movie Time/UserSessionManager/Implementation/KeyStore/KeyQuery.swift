//
//  KeyQuery.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//
import Foundation
import LocalAuthentication
class KeyQuery: KeyItem {

  // MARK: - Properties
  let matchLimit = kSecMatchLimit as String
  let returnData = kSecReturnData as String
  let itemAuthContext = kSecUseAuthenticationContext as String
  let context: LAContext
    
  // MARK: - Methods
    init(context: LAContext) {
        self.context = context
    }
    
  override func getItems() -> CFDictionary {
    let query: [String: Any] = [itemClass: kSecClassGenericPassword,
                                      itemService: service,
                                      matchLimit: kSecMatchLimitOne,
                                      returnData: true,
                                      itemAccessControl: access as Any,
                                      itemAuthContext: context]
    return query as CFDictionary
  }
}
