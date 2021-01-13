//
//  DTPersistenceTests.swift
//  DitoSDK Tests
//
//  Created by Mateus Rodrigues on 12/01/21.
//

import Foundation
import XCTest
@testable import DitoSDK


class DTPersistenceTests: XCTestCase{
    
    //MARK: Identify
    
    func testSaveIdentify(){
        
        let result = DTIdentifyDataManager.save(id: 1, reference: "ertit343434", signedRequest: "er")
        
        XCTAssertTrue(result, "Result must be true")
    }
    
    func testFetchIdentify(){
        
        let result = DTIdentifyDataManager.fetch()

        XCTAssertNotNil(result, "Result must be not nil")
    }
    
    func testDeleteIdentify(){
        
        let result = DTIdentifyDataManager.delete()

        XCTAssertTrue(result, "Result must be true")
    }
    
    //MARK: Track
    
    func testSaveTrack(){
        
        let result = DTTrackDataManager.save(action: "toque-no-botao-de-compra", reference: "ertit343434", status: 1, send: true)
        
        XCTAssertTrue(result, "Result must be true")
    }
    
    func testFetchTrack(){
        
        let result = DTTrackDataManager.fetch()
   
        XCTAssertFalse(result.isEmpty,"Result must be false")
    }
    
    func testFetchBySendTrack(){
        
        let result = DTTrackDataManager.fetchBySend(send: true)

        XCTAssertFalse(result.isEmpty,"Result must be false")
    }
    
    func testDeleteTrack(){
        
        let result = DTTrackDataManager.deleteBySend(send: true)

        XCTAssertTrue(result, "Result must be true")
    }
    
    //MARK: Notify
    
    func testSaveNotify(){
        
        let result = DTNotificationReadDataManager.save(reference: "ertit343434", send: true, json: Data())
        
        XCTAssertTrue(result, "Result must be true")
    }
    
    func testFetchNotify(){
    
        _ = DTNotificationReadDataManager.save(reference: "ertit343434", send: true, json: Data())
        _ = DTNotificationReadDataManager.save(reference: "ertit343434", send: true, json: Data())
        _ = DTNotificationReadDataManager.save(reference: "ertit343434", send: true, json: Data())
        
        let result = DTNotificationReadDataManager.fetch()
        
        XCTAssertNotNil(result, "Result must be not nil")
    }
    
    func testDeleteNotify(){
        
        let result = DTNotificationReadDataManager.deleteBySend(send: true)

        XCTAssertTrue(result, "Result must be true")
    }
    
}
