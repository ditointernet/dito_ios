//
//  Extensions.swift
//  iOS Example
//
//  Created by Rodrigo Damacena Gamarra Maciel on 11/01/21.
//

import Foundation

extension Bundle {
    
    var apiKey: String {
        return object(forInfoDictionaryKey: "ApiKey") as? String ?? ""
    }
    
    var apiSecret: String {
        return object(forInfoDictionaryKey: "ApiSecret") as? String ?? ""
    }
}
