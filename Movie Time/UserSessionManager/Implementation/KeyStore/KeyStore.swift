//
//  KeyStore.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//
import Foundation
final class KeyStore {
    
    static func findItem(query: KeyQuery) throws -> Data? {
      var queryResult: AnyObject?
      let status = withUnsafeMutablePointer(to: &queryResult) {
          SecItemCopyMatching(query.getItems(), UnsafeMutablePointer($0))
      }

      if status == errSecItemNotFound {
        return nil
      }
      
      if errSecUserCanceled == status || errSecAuthFailed == status {
         return nil
      }
        
      guard status == noErr else {
          throw KeyStoreError.Unknown
      }
      guard let itemData = queryResult as? Data else {
          throw KeyStoreError.TypeMismatch
      }

      return itemData
    }

    static func save(item: KeyItemWithData) throws {
        let status = SecItemAdd(item.getItems(), nil)
      guard status == noErr else {
        throw KeyStoreError.Unknown
      }
    }

    static func delete(item: KeyItem) throws {
      let status = SecItemDelete(item.getItems())
      guard status == noErr || status == errSecItemNotFound else {
          throw KeyStoreError.Unknown
      }
    }
    
}

enum KeyStoreError: LocalError {
    case Unknown
    case TypeMismatch
    
    var localizedDescription: String {
        StringResource.keyStoreError
    }
}
