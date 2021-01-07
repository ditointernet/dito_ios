//
//  Identify.swift
//  DitoSDK
//
//  Created by Willian Junior Peres De Pinho on 22/12/20.
//

import Foundation

struct DTIdentify {
    
    private let service: DTIdentifyService
    
    init(service: DTIdentifyService = .init()) {
        self.service = service
    }
    
    func identify(credentials: DTCredentials, data: DTUser) {
        
        let sigunpRequest = DTSignupRequest(platformApiKey: DTInitialize.apiKey,
                                            sha1Signature: DTInitialize.signature,
                                            userData: data)
                
        service.signup(network: "portal", id: credentials.id, data: sigunpRequest) { (identify, error) in
            
            if let error = error {
                #warning("TODO: implement logger")
                print(error.localizedDescription)
            } else {
                #warning("TODO: save reference in cache")
                print(identify?.reference)
            }
        }
    }
}
