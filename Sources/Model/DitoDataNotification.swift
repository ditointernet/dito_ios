//
//  DitoDataNotification.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 27/01/21.
//

import Foundation

struct DitoDataNotification: Codable {
    
    let identifier: String
    let reference: String

    init(identifier: String, reference: String) {
        
        self.identifier = identifier
        self.reference = reference
    }
    
    enum CodingKeys: String, CodingKey {
        case identifier, reference
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(reference, forKey: .reference)
    }
}
