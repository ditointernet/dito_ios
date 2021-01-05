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
                birthday: String? = nil,
                location: String? = nil,
                createdAt: Date? = Date(),
                json: AnyObject? = nil) {
        
        self.name = name
        self.gender = gender?.rawValue
        self.email = email
        self.birthday = birthday?.formatToDitoDate
        self.location = location
        self.createdAt = createdAt?.formatToISO
        self.data = Util.toString(from: json)
    }
}
