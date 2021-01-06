//
//  Util.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 04/01/21.
//

import Foundation


class Util {
    
    static func toString(from json: Any?) -> String? {
        
        guard let json = json else { return nil }
        
        do {
            let data =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        
        } catch let error {
            #warning("TODO: implement logger")
            print(error)
            return nil
        }
    }
}
