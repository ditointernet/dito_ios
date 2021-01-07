//
//  DTIdentifyTests.swift
//  DitoSDKTests
//
//  Created by brennobemoura on 06/01/21.
//

import XCTest
@testable import DitoSDK

class DTIdentifyTests: DTTestCase {
    
    func testJsonIntegrity() {
    
        let key1 = "name of User"
        let value1 = "Will cause and error"
        let key2 = "user-age"
        let value2 = 1
        
        let jsonDictionary: [String: Any] = [key1: value1, key2: value2]
        
        let expectedKey1 = key1.split(separator: " ").joined(separator: "-").lowercased()
        let expectedValue2 = "\(value2)"
        
        let user = DTUser(
            name: "Brenno de Moura",
            gender: .masculino,
            email: "teste@teste.com.br",
            birthday: Date(),
            location: "São Paulo",
            createdAt: Date(),
            json: jsonDictionary
        )
        
        guard let data = user.data?.data(using: .utf8) else {
            XCTAssertTrue(false, "Data in DTUser is empty and that was not expecteded")
            return
        }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            XCTAssertNotNil(dictionary)
            XCTAssertNil(dictionary?[key1])
            XCTAssertNotNil(dictionary?[expectedKey1])
            XCTAssertEqual(dictionary?[expectedKey1] as? String, value1)
            XCTAssertEqual(dictionary?[key2] as? String, expectedValue2)
        } catch let error {
            XCTAssertTrue(false, "\(error)")
        }
    }
    
    func testCreateAt() {
        let createdAt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss -z"
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: nil,
            birthday: nil,
            location: nil,
            createdAt: createdAt,
            json: nil
        )
        
        XCTAssertEqual(dateFormatter.string(from: createdAt), user.createdAt)
    }
    
    func testInvalidEmail() {
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
    
    func testValidEmail() {
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
        
        XCTAssertEqual(user.email, email)
    }
    
    func testValidDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: nil,
            birthday: date,
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        XCTAssertEqual(user.birthday, dateFormatter.string(from: date))
    }
    
    func testIdentify() {
        let expect = expectation(description: "register an user")
        
        let identifyService = MockDTIdentifyService()
        let credentials = DTCredentials(id: "1020")
        
        var error: Error? = nil
        var successed: Bool = false
        
        let user = DTUser(
            name: "Brenno de Moura",
            gender: .masculino,
            email: "teste@teste.com",
            birthday: Date(),
            location: "Goiânia",
            createdAt: Date(),
            json: nil
        )
        
        identifyService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        DTInitialize.identify(credentials: credentials, data: user, service: identifyService)
        wait(for: [expect], timeout: timeout)
        
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
    }

}
