//
//  MockDTInitialize.swift
//  DitoSDK Tests
//
//  Created by brennobemoura on 07/01/21.
//

@testable import DitoSDK

extension DTInitialize {
    
    static func identify(id: String,
                         data: DTUser,
                         sha1Signature: String = DTInitialize.signature,
                         service: DTIdentifyService) {
        
        let identify = DTIdentify(service: service)
        identify.identify(id: id, data: data, sha1Signature: sha1Signature)
    }
    
    static func track(event: DTEvent,
                      service: DTTrackService) {
        
        let dtTrack = DTTrack(service: service)
        dtTrack.track(data: event)
    }
}
