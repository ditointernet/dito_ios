//
//  DTIdentifyTests.swift
//  DitoSDKTests
//
//  Created by brennobemoura on 06/01/21.
//

import XCTest
@testable import DitoSDK

class DTIdentifyTests: DTTestCase {
    
    func testUserJsonIntegrity() {
    
        let key1 = "name of User"
        let value1 = "Will cause and error"
        let key2 = "user_age"
        let value2 = 1
        
        let jsonDictionary: [String: Any] = [key1: value1, key2: value2]
        
        let expectedKey1 = key1.split(separator: " ").joined(separator: "_").uppercased()
        let expectedValue2 = "\(value2)"
        
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
            XCTAssertNil(dictionary?[key1])
            XCTAssertNotNil(dictionary?[expectedKey1])
            XCTAssertTrue(dictionary?[expectedKey1] as? String == value1)
            XCTAssertTrue(dictionary?[key2] as? String == expectedValue2)
        } catch let error {
            assert(false, "\(error)")
        }
    }
    
    func testInvalidUserEmail() {
        let email = "a bc@test.com"
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: email,
            birthday: nil,
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        XCTAssertNil(user.email)
    }
    
    func testValidUserEmail() {
        let email = "a_bc@test.com"
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: email,
            birthday: nil,
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        XCTAssertTrue(user.email == email)
    }
    
    func testInvalidUserDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: nil,
            birthday: dateFormatter.string(from: date),
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        XCTAssertNil(user.birthday)
    }
    
    func testValidUserDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: nil,
            birthday: dateFormatter.string(from: date),
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        XCTAssertTrue(user.birthday == dateFormatter.string(from: date))
    }
    
    func testUserIdentify() {
        let expect = expectation(description: "register an null user with empty json")
        
        let credentials = DTCredentials(id: "1020")
        
        let user = DTUser(
            name: "Brenno de Moura",
            gender: .masculino,
            email: "teste@teste.com",
            birthday: "09/12/1970",
            location: "Goiânia",
            createdAt: Date(),
            json: nil
        )
        
        DTInitialize.identify(credentials: credentials, data: user)
        
        #warning("TODO: Wait for user register")
        expect.fulfill()
        
        #warning("TODO: Wait expectation")
        wait(for: [expect], timeout: timeout)
        
        #warning("TODO: Check if user is registered")
    }

}
