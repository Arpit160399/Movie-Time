//
//  Movie_TimeUITests.swift
//  Movie TimeUITests
//
//  Created by Arpit Singh on 27/01/23.
//

@testable import Movie_Time
import XCTest

final class Movie_TimeUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launchEnvironment = ["-UITest":"Login"]
        app.launch()
    }
    

    func testEmailValidation() throws {
        let elements = app.scrollViews.otherElements
        
        let emailTextField = elements.textFields["email"]
        XCTAssertTrue( emailTextField.waitForExistence(timeout: 1.0))
        
        emailTextField.tap()
        emailTextField.typeText("Arpit@gmailcom")
       
        
        let passwordSecureTextField = elements.secureTextFields["password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
      
        let showButton = elements.buttons["hide"]
        showButton.tap()
        
        app/*@START_MENU_TOKEN@*/ .buttons/*[[".scrollViews.buttons",".buttons"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .staticTexts["Sign In"].tap()
        
        let signOut = app.buttons.containing(.staticText, identifier: "Sign Out")
    
        XCTAssertFalse(signOut.element.waitForExistence(timeout: 1.5))
    }

    func testPasswordValidation() throws {
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let emailTextField = elementsQuery.textFields["email"]
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 1.0))
        emailTextField.tap()
        emailTextField.typeText("Arpit@gmail.com")
        
        let passwordSecureTextField = elementsQuery.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("1234")
        XCTAssertTrue(passwordSecureTextField.exists)
        
        let showButton = elementsQuery.buttons["hide"]
        showButton.tap()
        let hideButton = elementsQuery.buttons["show"]
        hideButton.tap()
        
        let signInButton = app/*@START_MENU_TOKEN@*/ .buttons/*[[".scrollViews.buttons",".buttons"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .staticTexts["Sign In"]
        signInButton.tap()
        let error = app.alerts["Error Occurred"]
        XCTAssertTrue(error.exists)
    }
    
    func testUserLogin() {

        let elements = app.scrollViews.otherElements
        
        let emailTextField = elements.textFields["email"]
        XCTAssertTrue( emailTextField.waitForExistence(timeout: 1.0))
        emailTextField.tap()
        emailTextField.typeText("Arpit@gmail.com")

      
        let passwordSecureTextField = elements.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        
        let showButton = elements.buttons["hide"]
        showButton.tap()
        
        let signInButton = app .buttons.staticTexts["Sign In"]
        signInButton.tap()
        
        let signOutButton = app.buttons.staticTexts["Sign Out"]
        XCTAssertTrue(signOutButton.waitForExistence(timeout: 1.5))
    }
}
