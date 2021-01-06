//
//  Encodable+Extensions.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 06/01/21.
//

import Foundation

extension Encodable {
    
    var toString: String? {
        
        do {
            let jsonData = try JSONEncoder().encode(self)
            return String(data: jsonData, encoding: .utf8).unwrappedValue
        } catch let error {
            #warning("TODO: implement logger")
            print(error)
            return nil
        }
    }
}
