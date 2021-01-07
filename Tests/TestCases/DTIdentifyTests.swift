//
//  DTIdentifyTests.swift
//  DitoSDKTests
//
//  Created by brennobemoura on 06/01/21.
//

import XCTest
@testable import DitoSDK

class DTIdentifyTests: DTTestCase {
    
    func testCreateAt() {
        let expect = expectation(description: "register an user with an valid created at date")
        
        let identifyService = MockDTIdentifyService()
        let credentials = DTCredentials(id: "1020")
        
        let createdAt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss -z"
        
        var error: Error? = nil
        var successed: Bool = false
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: nil,
            birthday: nil,
            location: nil,
            createdAt: createdAt,
            json: nil
        )
        
        identifyService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        DTInitialize.identify(credentials: credentials, data: user, service: identifyService)
        wait(for: [expect], timeout: timeout)
        
        XCTAssertEqual(dateFormatter.string(from: createdAt), user.createdAt)
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
    }
    
    func testInvalidEmail() {
        let expect = expectation(description: "register an user with an invalid email")
        
        let identifyService = MockDTIdentifyService()
        let credentials = DTCredentials(id: "1020")
        
        let email = "a bc@test.com"
        
        var error: Error? = nil
        var successed: Bool = false
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: email,
            birthday: nil,
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        identifyService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        DTInitialize.identify(credentials: credentials, data: user, service: identifyService)
        wait(for: [expect], timeout: timeout)
        
        XCTAssertNil(user.email)
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
    }
    
    func testValidEmail() {
        let expect = expectation(description: "register an user with a valid email")
        
        let identifyService = MockDTIdentifyService()
        let credentials = DTCredentials(id: "1020")
        
        let email = "a_bc@test.com"
        
        var error: Error? = nil
        var successed: Bool = false
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: email,
            birthday: nil,
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        identifyService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        DTInitialize.identify(credentials: credentials, data: user, service: identifyService)
        wait(for: [expect], timeout: timeout)
        
        XCTAssertEqual(user.email, email)
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
    }
    
    func testValidDate() {
        let expect = expectation(description: "register an user with an valid birthdate")
        
        let identifyService = MockDTIdentifyService()
        let credentials = DTCredentials(id: "1020")
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var error: Error? = nil
        var successed: Bool = false
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: nil,
            birthday: date,
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        identifyService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        DTInitialize.identify(credentials: credentials, data: user, service: identifyService)
        wait(for: [expect], timeout: timeout)
        
        XCTAssertEqual(user.birthday, dateFormatter.string(from: date))
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
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
    
    func testIdentifySHA1Algorithm() {
        let expect = expectation(description: "register an user with sha1 Algorithm")
        
        let identifyService = MockDTIdentifyService()
        let credentials = DTCredentials(id: "1020")
        
        var error: Error? = nil
        var successed: Bool = false
        
        let user = DTUser(
            name: nil,
            gender: nil,
            email: nil,
            birthday: nil,
            location: nil,
            createdAt: nil,
            json: nil
        )
        
        identifyService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        DTInitialize.identify(
            credentials: credentials,
            data: user,
            sha1Signature: sha1Hash(Self.apiSecret),
            service: identifyService
        )
        wait(for: [expect], timeout: timeout)
        
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
    }
}

extension DTIdentifyTests {
    
    func sha1Hash(_ string: String) -> String {
        SHA1.hexString(from: string)?
            .lowercased()
            .replacingOccurrences(of: " ", with: "") ?? ""
    }
}
