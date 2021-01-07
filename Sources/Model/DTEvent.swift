//
//  DTEvent.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 05/01/21.
//

import Foundation

public struct DTEvent: Encodable {
    
    let action: String?
    let revenue: Double?
    let createdAt: String?
    let data: String?
    
    public init(action: String? = nil,
                revenue: Double? = nil,
                createdAt: Date? = Date(),
                json: Any? = nil) {
        
        self.action = action?.formatToDitoString
        self.revenue = revenue
        self.createdAt = createdAt?.formatToISO
        self.data = Util.toString(from: json)
    }
    
    enum CodingKeys: String, CodingKey {
        case action, revenue, data
        case createdAt = "created_at"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(revenue, forKey: .revenue)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(data, forKey: .data)
    }
}
