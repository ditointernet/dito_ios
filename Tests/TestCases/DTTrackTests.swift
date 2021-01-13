////
////  DTTrackTests.swift
////  DitoSDK Tests
////
////  Created by brennobemoura on 06/01/21.
////
//
//import XCTest
//@testable import DitoSDK
//
//class DTTrackTests: DTTestCase {
//    
//    func testSomething() {
//    }
//    
//    func testInvalidAction() {
//        let expect = expectation(description: "register track")
//        
//        let action = "Botao track pressionado"
//        let expectedAction = action.split(separator: " ").joined(separator: "-").lowercased()
//        
//        let credentials = registerUser()
//        let trackService = MockDTTrackService()
//        
//        var error: Error? = nil
//        var successed: Bool = false
//        
//        let event = DTEvent(
//            action: action,
//            json: nil
//        )
//        
//        trackService.onResult {
//            successed = $0 == nil
//            error = $0
//            expect.fulfill()
//        }
//        
//        DTInitialize.track(credentials: credentials, event: event, service: trackService)
//        wait(for: [expect], timeout: timeout)
//        
//        XCTAssertEqual(event.action, expectedAction)
//        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
//    }
//    
//    func testValidAction() {
//        let expect = expectation(description: "register track with valid action")
//        
//        let action = "botao-track-pressionado"
//        
//        let credentials = registerUser()
//        let trackService = MockDTTrackService()
//        
//        var error: Error? = nil
//        var successed: Bool = false
//        
//        let event = DTEvent(
//            action: action,
//            json: nil
//        )
//        
//        trackService.onResult {
//            successed = $0 == nil
//            error = $0
//            expect.fulfill()
//        }
//        
//        DTInitialize.track(credentials: credentials, event: event, service: trackService)
//        wait(for: [expect], timeout: timeout)
//        
//        XCTAssertEqual(event.action, action)
//        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
//    }
//    
//    func testTrack() {
//        let expect = expectation(description: "register track")
//        
//        let action = "botao-track-pressionado"
//        
//        let credentials = registerUser()
//        let trackService = MockDTTrackService()
//        
//        var error: Error? = nil
//        var successed: Bool = false
//        
//        let event = DTEvent(
//            action: action,
//            json: nil
//        )
//        
//        trackService.onResult {
//            successed = $0 == nil
//            error = $0
//            expect.fulfill()
//        }
//        
//        DTInitialize.track(credentials: credentials, event: event, service: trackService)
//        wait(for: [expect], timeout: timeout)
//        
//        XCTAssertTrue(successed, error?.localizedDescription ?? "Test didn't success")
//    }
//}
//
//extension DTTrackTests {
//    func registerUser() -> DTCredentials {
//        
//        let credentials = DTCredentials(id: "1020")
//        
//        let user = DTUser(
//            name: "Rodrigo Maciel",
//            gender: .masculino,
//            email: "teste@teste.com.br",
//            birthday: Date(),
//            location: "São Paulo",
//            createdAt: Date(),
//            json: nil
//        )
//        
//        DTInitialize.identify(credentials: credentials, data: user)
//        return credentials
//    }
//}
