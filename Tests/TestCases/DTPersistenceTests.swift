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
        
        let result = DTIdentifyDataManager.save(id: "sdk223", reference: "drrt", json: "rtrt:{{rtrt:}}", send: true)
        
        XCTAssertTrue(result, "Result must be true when nothing idetify has been saved")
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
        
        let result = DTTrackDataManager.save(event: "toque-no-botao-de-cancelar", retry: 2)
        
        XCTAssertTrue(result, "Result must be true")
    }
    
    func testFetchTrack(){
        
        let result = DTTrackDataManager.fetch()
   
        XCTAssertFalse(result.isEmpty,"Result must be false")
    }
    
    
    func testDeleteTrack(){
        
        let result = DTTrackDataManager.delete()

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
