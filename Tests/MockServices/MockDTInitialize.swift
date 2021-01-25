//
//  MockDTInitialize.swift
//  DitoSDK Tests
//
//  Created by brennobemoura on 07/01/21.
//

@testable import DitoSDK

extension Dito {
    
    static func identify(id: String,
                         data: DitoUser,
                         sha1Signature: String = Dito.signature,
                         service: DitoIdentifyService) {
        
        let identify = DitoIdentify(service: service)
        identify.identify(id: id, data: data, sha1Signature: sha1Signature)
    }
    
    static func track(event: DitoEvent,
                      service: DitoTrackService) {
        
        let dtTrack = DitoTrack(service: service)
        dtTrack.track(data: event)
    }
    
    convenience init(apiKey: String, apiSecret: String) {
      
        Dito.apiKey = apiKey
        Dito.apiSecret = apiSecret
        Dito.signature = apiSecret.sha1
        self.init()
    }
}
