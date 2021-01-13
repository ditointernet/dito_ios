////
////  MockDTInitialize.swift
////  DitoSDK Tests
////
////  Created by brennobemoura on 07/01/21.
////
//
//@testable import DitoSDK
//
//extension DTInitialize {
//    
//    static func identify(credentials: DTCredentials,
//                         data: DTUser,
//                         sha1Signature: String = DTInitialize.signature,
//                         service: DTIdentifyService) {
//        
//        let identify = DTIdentify(service: service)
//        identify.identify(credentials: credentials, data: data, sha1Signature: sha1Signature)
//    }
//    
//    static func track(credentials: DTCredentials,
//                      event: DTEvent,
//                      service: DTTrackService) {
//        
//        let dtTrack = DTTrack(service: service)
//        dtTrack.track(credentials: credentials, data: event)
//    }
//}
