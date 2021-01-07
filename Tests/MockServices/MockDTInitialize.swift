//
//  MockDTInitialize.swift
//  DitoSDK Tests
//
//  Created by brennobemoura on 07/01/21.
//

@testable import DitoSDK

extension DTInitialize {
    
    static func identify(credentials: DTCredentials,
                             data: DTUser,
                             service: DTIdentifyService) {
        
        let identify = DTIdentify(service: service)
        identify.identify(credentials: credentials, data: data)
    }
}
