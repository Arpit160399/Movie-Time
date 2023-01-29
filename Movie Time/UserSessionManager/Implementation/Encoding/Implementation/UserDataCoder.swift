//
//  UserDataEncoder.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//

import Foundation

class UserDataCoder: UserDataEncoding {
    
  // MARK: - Methods
   init() {}

   func encode(userData: Session) -> Data? {
        let encoder = PropertyListEncoder()
        let data = try? encoder.encode(userData)
        return data
  }
  
  func decode(data: Data) -> Session? {
     let decoder = PropertyListDecoder()
     let user = try? decoder.decode(Session.self, from: data)
     return user
  }
}
