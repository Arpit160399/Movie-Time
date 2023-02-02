//
//  Movie_TimeUITestsLaunchTests.swift
//  Movie TimeUITests
//
//  Created by Arpit Singh on 27/01/23.
//

import XCTest

final class Movie_TimeUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
    }
}
