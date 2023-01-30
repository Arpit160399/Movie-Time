//
//  StringResource.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
/// To Aggregate Constant String Values
public enum StringResource {
    
    static var biometricAuthMessage: String { "For a secure access to your data" }
    
    static var unknownErrorMessage: String { "unknown error during this operation." }
    
    static var userValidationError: String { "incorrect password or user email enter." }
    
    static var noUserErrorMessage: String { "no user with email is currently registered." }
    
    static var keyStoreError: String { "failed process this secure operation at the moment." }
    
    static var sessionError: String { "user session has expired." }
    
    static var errorTitle: String { "Error Occurred" }
    
    static var alreadyUserExistError: String { "user with provided info already exist in the system." }
    static var appTitle : String { "Movie Time" }
}
