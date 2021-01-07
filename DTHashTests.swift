//
//  DTHashTests.swift
//  DitoSDK Tests
//
//  Created by brennobemoura on 07/01/21.
//

import XCTest
import CryptoKit
@testable import DitoSDK

@available(iOS 13, *)
class DTHashTests: XCTestCase {
    
    func testHashCompatibility() {
        let string = "xcaoI1lXnyraH1MCQtRPkbUOAqAS6ywikNGQTiZw"
        
        XCTAssertEqual(cryptoSHA1Hash(string), sha1Hash(string))
    }
}

@available(iOS 13, *)
extension DTHashTests {
    func cryptoSHA1Hash(_ string: String) -> String {
        Insecure.SHA1.hash(data: string.data(using: .utf8) ?? Data())
            .map {
                String(format: "%02hhx", $0)
            }.joined()
    }
    
    func sha1Hash(_ string: String) -> String {
        SHA1.hexString(from: string)?
            .lowercased()
            .replacingOccurrences(of: " ", with: "") ?? ""
    }
}
