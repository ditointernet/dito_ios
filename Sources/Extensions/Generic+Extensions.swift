//
//  Generic+Extensions.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 07/01/21.
//

import Foundation

extension UserDefaults {
    
    private enum Keys {
        static let firstSave = "firstSave"
        static let identifyKey = "identify"
        static let savingState = "savingState"
        static let notificationRegisterKey = "notificationRegister"
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
    
    class var identify: IdentifyDefaults? {
        get {
            UserDefaults.standard.object(forKey: Keys.identifyKey) as? IdentifyDefaults
        }
        set {
            
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: Keys.identifyKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: Keys.identifyKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    class var savingState: Double {
        get {
            UserDefaults.standard.double(forKey: Keys.savingState)
        }
        set {
            
            if newValue == -1 {
                UserDefaults.standard.removeObject(forKey: Keys.savingState)
            }
            UserDefaults.standard.set(newValue, forKey: Keys.savingState)
            UserDefaults.standard.synchronize()
        }

    }
    
    class var notificationRegister: NotificationDefaults? {
        get {
            UserDefaults.standard.object(forKey: Keys.notificationRegisterKey) as? NotificationDefaults
        }
        set {
            
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: Keys.notificationRegisterKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: Keys.notificationRegisterKey)
                UserDefaults.standard.synchronize()
            }
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

extension Int {
    
    var toString: String {
        return String(self)
    }
}
