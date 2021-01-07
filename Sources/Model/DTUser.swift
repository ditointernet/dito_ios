//
//  DTUser.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 29/12/20.
//

import Foundation

public struct DTUser: Encodable {
    
    let name: String?
    let gender: String?
    let email: String?
    let birthday: String?
    let location: String?
    let createdAt: String?
    let data: String?
    
    public init(name: String? = nil,
                gender: DTGender? = nil,
                email: String? = nil,
                birthday: Date? = nil,
                location: String? = nil,
                createdAt: Date? = Date(),
                json: Any? = nil) {
        
        self.name = name
        self.gender = gender?.rawValue
        self.email = email
        self.birthday = birthday?.formatToDitoDate
        self.location = location
        self.createdAt = createdAt?.formatToISO
        self.data = Util.toString(from: json)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, gender, email, birthday, location, data
        case createdAt = "created_at"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(gender, forKey: .gender)
        try container.encode(email, forKey: .email)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(location, forKey: .location)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(data, forKey: .data)
    }
}
