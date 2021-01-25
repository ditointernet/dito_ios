//
//  DTTrackTests.swift
//  DitoSDK Tests
//
//  Created by brennobemoura on 06/01/21.
//

import XCTest
@testable import DitoSDK

class DTTrackTests: DTTestCase {
    
    func testSomething() {
    }
    
    func testInvalidAction() {
        let expect = expectation(description: "register track")
        
        let action = "Botao track pressionado"
        let expectedAction = action.split(separator: " ").joined(separator: "-").lowercased()
        
        registerUser()
        let trackService = MockDTTrackService()
        
        var error: Error? = nil
        var successed: Bool = false
        
        let event = DitoEvent(
            action: action,
            customData: nil
        )
        
        trackService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        Dito.track(event: event, service: trackService)
        wait(for: [expect], timeout: timeout)
        
        XCTAssertEqual(event.action, expectedAction)
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
    }
    
    func testValidAction() {
        let expect = expectation(description: "register track with valid action")
        
        let action = "botao-track-pressionado"
        
        registerUser()
        let trackService = MockDTTrackService()
        
        var error: Error? = nil
        var successed: Bool = false
        
        let event = DitoEvent(
            action: action,
            customData: nil
        )
        
        trackService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        Dito.track(event: event, service: trackService)
        wait(for: [expect], timeout: timeout)
        
        XCTAssertEqual(event.action, action)
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
    }
    
    func testTrack() {
        let expect = expectation(description: "register track")
        
        let action = "botao-track-pressionado"
        
        registerUser()
        let trackService = MockDTTrackService()
        
        var error: Error? = nil
        var successed: Bool = false
        
        let event = DitoEvent(
            action: action,
            customData: nil
        )
        
        trackService.onResult {
            successed = $0 == nil
            error = $0
            expect.fulfill()
        }
        
        Dito.track(event: event, service: trackService)
        wait(for: [expect], timeout: timeout)
        
        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
    }
}

extension DTTrackTests {
    func registerUser() {
        
        let id = "1020"
        
        let user = DitoUser(
            name: "Rodrigo Maciel",
            gender: .masculino,
            email: "teste@teste.com.br",
            birthday: Date(),
            location: "São Paulo",
            createdAt: nil,
            customData: nil
        )
        
        Dito.identify(id: id, data: user)
    }
}
