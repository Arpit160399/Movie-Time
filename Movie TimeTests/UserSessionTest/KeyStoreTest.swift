//
//  KeyStoreTest.swift
//  Movie TimeTests
//
//  Created by Arpit Singh on 28/01/23.
//
import LocalAuthentication
import XCTest
@testable import Movie_Time
final class KeyStoreTest: XCTestCase {

    private var context = LAContext()
    private var testData = UserSessionMockDataStack()
    
    func testSaveUserData() throws {
        let data = testData.getData()
        SecItemDelete(KeyItem().getItems())
        let keyItem = KeyItemWithData(data: data, context: context)
        try KeyStore.save(item: keyItem)
        SecItemDelete(KeyItem().getItems())
    }
    
    fileprivate func mockKeyStore(data: Data) {
            let keyItem = KeyItemWithData(data: data, context: context)
            SecItemAdd(keyItem.getItems(), nil)
    }
    
    func testDeleteUserData() throws {
        let value = testData.getData()
        mockKeyStore(data: value)
        let keyItem = KeyItem()
        try KeyStore.delete(item: keyItem)
    
    }

    fileprivate func testGetUserDataWithNoInitialData() throws {
        SecItemDelete(KeyItem().getItems())
        let keyItem = KeyQuery(context: context)
        let data = try KeyStore.findItem(query: keyItem)
        if data != nil {
            XCTFail("To fetch with validate data from keychain")
        }
    }
    
    fileprivate func testGetUserDataWithDifferentAuthCase() throws {
       
        let session = testData.getTestUserSession()
        let value = testData.getData(session)
        mockKeyStore(data: value)
        let decoder = JSONDecoder()
        
        for authCase in AuthCase.allCases {
            
            let keyItem = KeyQuery(context: authCase.getLAContext())
            let data = try KeyStore.findItem(query: keyItem)
            
            if authCase == .failure , data != nil  {
                XCTFail("To perform user validation")
            } else if authCase == .success {
                guard let data = data,
                      let current = try? decoder.decode(Session.self, from: data)
                else {  XCTFail("To decode the fetched data from keystore"); return }
                XCTAssertTrue(session.user.email == current.user.email,"Failed to fetch correct query item from keychain")
            }
        }
    }
    
    func testGetUserData() throws {
        try testGetUserDataWithNoInitialData()
        try testGetUserDataWithDifferentAuthCase()
    }
}

// Mocking Different Auth cases
enum AuthCase: String,CaseIterable {
    case success
    case failure
    
    func getLAContext() -> LAContext {
        switch self {
        case .success:
             return LAContext()
        case .failure:
             let context = LAContext()
             context.invalidate()
             return context
        }
    }
}
