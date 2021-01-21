//
//  DTEventRequest.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 05/01/21.
//

import Foundation


public struct DTEventRequest: Codable {
    
    let platformApiKey: String
    let sha1Signature: String
    let event: String
    var networkName: String = "pt"
    var encoding: String = "base64"
    
    public init(platformApiKey: String, sha1Signature: String, event: DTEvent) {
        
        self.platformApiKey = platformApiKey
        self.sha1Signature = sha1Signature
        self.event = event.toString.unwrappedValue
    }
   
    enum CodingKeys: String, CodingKey {
        case platformApiKey = "platform_api_key"
        case sha1Signature = "sha1_signature"
        case event
        case networkName = "network_name"
        case encoding
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(platformApiKey, forKey: .platformApiKey)
        try container.encode(sha1Signature, forKey: .sha1Signature)
        try container.encode(event, forKey: .event)
        try container.encode(networkName, forKey: .networkName)
        try container.encode(encoding, forKey: .encoding)
    }
}
