//
//  DitoTokenRequest.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 26/01/21.
//

import Foundation

struct DitoTokenRequest: Codable {
    
    let platformApiKey: String
    let sha1Signature: String
    let token: String
    let tokenType: String
    let platform: String = "Apple iPhone"
    
    init(platformApiKey: String, sha1Signature: String, token: String, tokenType: DitoTokenType) {
        
        self.platformApiKey = platformApiKey
        self.sha1Signature = sha1Signature
        self.token = token
        self.tokenType = tokenType.rawValue
    }
   
    enum CodingKeys: String, CodingKey {
        case platformApiKey = "platform_api_key"
        case sha1Signature = "sha1_signature"
        case token
        case tokenType = "ios_token_type"
        case platform
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(platformApiKey, forKey: .platformApiKey)
        try container.encode(sha1Signature, forKey: .sha1Signature)
        try container.encode(token, forKey: .token)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(platform, forKey: .platform)
    }
}
