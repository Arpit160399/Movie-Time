//
//  KeyItemWithData.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//

import Foundation
import LocalAuthentication
class KeyItemWithData: KeyItem {

  // MARK: - Properties
  let data: AnyObject
  let itemData = kSecValueData as String
  let context: LAContext
  let itemAuthContext = kSecUseAuthenticationContext as String
    
  // MARK: - Methods
    init(data: Data,context: LAContext) {
    self.data = data as AnyObject
    self.context = context
  }

  override func getItems() -> CFDictionary {
    let item: [String: Any] = [itemClass: kSecClassGenericPassword,
                                     itemService: service,
                                     itemData: data,
                                     itemAccessControl: access as Any,
                                     itemAuthContext: context]
    return item as CFDictionary
  }

}
