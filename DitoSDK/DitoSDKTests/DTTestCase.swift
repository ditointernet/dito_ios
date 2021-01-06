//
//  DTTestCase.swift
//  DitoSDKTests
//
//  Created by brennobemoura on 06/01/21.
//

import XCTest
@testable import DitoSDK

class DTTestCase: XCTestCase {
    static let apiKey: String = "MjAxOS0wMi0wNyAxNDo1Mzo0OCAtMDIwMFRlc3RlIC0gSUI2NDE"
    static let apiSecret: String = "xcaoI1lXnyraH1MCQtRPkbUOAqAS6ywikNGQTiZw"
    
    let timeout: TimeInterval = 10
    
    override func setUp() {
        super.setUp()
        
        DTInitialize.configure(
            apiKey: Self.apiKey,
            apiSecret: Self.apiSecret
        )
    }
    
    /**
     Wait the expression to be asserted on specific queue
     
     - Parameters:
        - queue: A instance of `DispatchQueue` to wait for expression asserted
        - expression: The block to be assert
     */
    func assert(on queue: DispatchQueue, expression: @escaping () -> Void) {
        let expect = expectation(description: "expression to be completed")
            
        queue.async {
            expression()
            expect.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
}
