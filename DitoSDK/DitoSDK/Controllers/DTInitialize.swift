//
//  DTInitialize.swift
//  DitoSDK
//
//  Created by Willian Junior Peres De Pinho on 23/12/20.
//

import Foundation


public class DTInitialize {
    
    private var apiKey: String = ""
    private var apiSecret: String = ""
    private var signature: String = ""
    
    public init() { }
    
    public func configure(apiKey: String, apiSecret: String) {
        
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.signature = apiSecret.sha1
    }
    
    public func identify(credentials: DTCredentials, accessToken: String?, data: DTParameters) {
    }
    
    public func track(credentials: DTCredentials, event: DTParameters) {
    }

}

