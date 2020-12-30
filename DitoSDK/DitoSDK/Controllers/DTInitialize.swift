//
//  DTInitialize.swift
//  DitoSDK
//
//  Created by Willian Junior Peres De Pinho on 23/12/20.
//

import Foundation

public struct DTInitialize {
    
    static var apiKey: String = ""
    static var apiSecret: String = ""
    static var signature: String = ""
        
    public static func configure(apiKey: String, apiSecret: String) {
        
        DTInitialize.apiKey = apiKey
        DTInitialize.apiSecret = apiSecret
        DTInitialize.signature = apiSecret.sha1
    }
    
    public static func identify(credentials: DTCredentials, data: DTUser) {
        
        let identify = DTIdentify()
        identify.identify(credentials: credentials, data: data)
    }
    
    public static func track(credentials: DTCredentials, event: DTParameters) {
    }

}

