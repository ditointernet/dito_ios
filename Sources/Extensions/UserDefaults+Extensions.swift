//
//  UserDefaults+Extensions.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 07/01/21.
//

import Foundation

extension UserDefaults {
    
    private enum Keys {
        static let reference = "reference"
        static let firstSave = "firstSave"
    }
    
    class var reference: String {
        get {
            UserDefaults.standard.string(forKey: Keys.reference).unwrappedValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.reference)
            UserDefaults.standard.synchronize()
        }
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
