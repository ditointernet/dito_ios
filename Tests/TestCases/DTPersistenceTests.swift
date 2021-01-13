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
    
    func testSaveIdentify(){
        
        let result = DTIdentifyDataManager.shared.save(id: 1, reference: "", signedRequest: "")
        
        XCTAssertTrue(result, "Result must be true")
    }
    
    func testFetchIdentify(){
        
//        let result = DTIdentifyDataManager.shared.fetch()
//
//        print("ID \(result?.id)")
//        XCTAssertNotNil(result, "Result must be not nil")
    }
}
