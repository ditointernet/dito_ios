//
//  UserDefaults+Extensions.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 07/01/21.
//

import Foundation

extension UserDefaults {
    
    private enum Keys {
        static let firstSave = "firstSave"
    }
    
    class var firstSave: Bool {
         get {
             UserDefaults.standard.bool(forKey: Keys.firstSave)
         }
         set {
             UserDefaults.standard.set(newValue, forKey: Keys.firstSave)
             UserDefaults.standard.synchronize()
         }
     }
}

extension Bundle {
    
    var apiKey: String {
        return object(forInfoDictionaryKey: "ApiKey") as? String ?? ""
    }
    
    var apiSecret: String {
        return object(forInfoDictionaryKey: "ApiSecret") as? String ?? ""
    }
}
