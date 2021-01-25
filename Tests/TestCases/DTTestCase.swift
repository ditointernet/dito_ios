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
        
        let dito = Dito(apiKey: Self.apiKey, apiSecret: Self.apiSecret)
        dito.configure()
    }
}
