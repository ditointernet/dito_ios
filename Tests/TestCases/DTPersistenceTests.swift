//
//  DTPersistenceTests.swift
//  DitoSDK Tests
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import XCTest
@testable import DitoSDK


class DTPersistenceTests: XCTestCase {
    
    //MARK: Identify
    
    func testSaveIdentify() {
        
        let dataManager = DitoIdentifyDataManager()
        let result = dataManager.save(id: "sdk223", reference: "drrt", json: "rtrt:{{rtrt:}}", send: true)
        
        XCTAssertTrue(result, "Result must be true when nothing idetify has been saved")
    }
    
    func testFetchIdentify() {
        
        let dataManager = DitoIdentifyDataManager()
        let result = dataManager.fetch

        XCTAssertNotNil(result, "Result must be not nil")
    }
    
    func testDeleteIdentify() {
        
        let dataManager = DitoIdentifyDataManager()
        let result = dataManager.delete(id: "1021")
        
        XCTAssertTrue(result, "Result must be true")
    }
    
    //MARK: Track
    
    func testSaveTrack() {
        
        let dataManager = DitoTrackDataManager()
        let result = dataManager.save(event: "toque-no-botao-de-cancelar", retry: 1)
        
        XCTAssertTrue(result, "Result must be true")
    }
    
    func testFetchTrack() {
        
        let dataManager = DitoTrackDataManager()
        let result = dataManager.fetchAll
   
        XCTAssertFalse(result.isEmpty, "Result must be false")
    }
    
    func testDeleteTrack() {
        
        let dataManager = DitoTrackDataManager()
        let tracks = dataManager.fetchAll
        var result: Bool = false
        
        if !tracks.isEmpty, let id = tracks.first?.objectID {
            result = dataManager.delete(with: id)
        }

        XCTAssertTrue(result, "Result must be true")
    }
    
    //MARK: Notify
    
    func testSaveNotify() {
        
        let result = DitoNotificationReadDataManager.save(reference: "ertit343434", send: true, json: Data())
        
        XCTAssertTrue(result, "Result must be true")
    }
    
    func testFetchNotify() {
    
        _ = DitoNotificationReadDataManager.save(reference: "ertit343434", send: true, json: Data())
        _ = DitoNotificationReadDataManager.save(reference: "ertit343434", send: true, json: Data())
        _ = DitoNotificationReadDataManager.save(reference: "ertit343434", send: true, json: Data())
        
        let result = DitoNotificationReadDataManager.fetch()
        
        XCTAssertNotNil(result, "Result must be not nil")
    }
    
    func testDeleteNotify() {
        
        let dataManager = DitoNotificationReadDataManager()
        let notifications = dataManager.fetchAll
        var result: Bool = false
        
        if !notifications.isEmpty, let id = notifications.first?.objectID {
            result = dataManager.delete(with: id)
        }
        XCTAssertTrue(result, "Result must be true")
    }
    
}
