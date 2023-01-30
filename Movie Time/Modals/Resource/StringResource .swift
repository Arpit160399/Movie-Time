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
    
    static var signInButton: String { "Sign In" }
    
    static var signUpButton: String { "Sign Up" }
    
    static var signUpTitle: String { "Come on join the club" }
    
    static var signInTitle: String { "Hi there long time no see !" }
    
    static var navigationToSignIn: String { "Are you already in the Club ?" }
    
    static var navigationToSignUp: String { "Are you new here ?" }
    
    static var alreadyUserExistError: String { "user with provided info already exist in the system." }
    static var passwordValidationError: String {  "Please create an password with at-least greater than 6 character " }
    static var appTitle : String { "Movie Time" }
}
