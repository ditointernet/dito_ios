//
//  DTIdentifyTests.swift
//  DitoSDKTests
//
//  Created by brennobemoura on 06/01/21.
//

import XCTest
@testable import DitoSDK

class DTIdentifyTests: DTTestCase {
    // testar empty json
    // testar gender
    // testar email [c/i]
    // testar aniversário
    // testar data
    
    func testEmptyJsonWithNullUser() {
        let expect = expectation(description: "register an null user with empty json")
        
        let credentials = DTCredentials(id: "1020")
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: nil,
            birthday: nil,
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        DTInitialize.identify(credentials: credentials, data: user)
        
        #warning("TODO: Wait for user register")
        expect.fulfill()
        
        #warning("TODO: Wait expectation")
        wait(for: [expect], timeout: timeout)
        
        #warning("TODO: Check if user is registered")
    }
    
    func testUserJsonIntegrity() {
    
        let key = "name of user"
        let value = "Will cause and error"
        let jsonDictionary = [key: value]
        
        let expectedKey = key.split(separator: " ").joined(separator: "_")
        
        let user = DTUser(
            name: "Brenno de Moura",
            gender: .masculino,
            email: "teste@teste.com.br",
            birthday: "10/04/2000",
            location: "São Paulo",
            createdAt: Date(),
            json: nil//jsonDictionary
        )
        
        guard let data = user.data?.data(using: .utf8) else {
            assert(false, "Data in DTUser is empty and that was not expecteded")
            return
        }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            XCTAssertNotNil(dictionary)
            XCTAssertNil(dictionary?[key])
            XCTAssertNotNil(dictionary?[expectedKey])
            XCTAssertTrue(dictionary?[expectedKey] as? String == value)
        } catch let error {
            assert(false, "\(error)")
        }
    }
}
