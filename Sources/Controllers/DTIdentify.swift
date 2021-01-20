//
//  Identify.swift
//  DitoSDK
//
//  Created by Willian Junior Peres De Pinho on 22/12/20.
//

import Foundation

struct DTIdentify {
    
    private let service: DTIdentifyService
    private let identifyOffline: DTIdentifyOffline
    
    init(service: DTIdentifyService = .init(), identifyOffline: DTIdentifyOffline = .init()) {
        self.service = service
        self.identifyOffline = identifyOffline
    }
    
    func identify(id: String, data: DTUser, sha1Signature: String = DTInitialize.signature) {
        
        DispatchQueue.global().async {
            
            let signupRequest = DTSignupRequest(platformApiKey: DTInitialize.apiKey,
                                                sha1Signature: sha1Signature,
                                                userData: data)
            
            guard data.email != nil else {
                return
            }
            service.signup(network: "portal", id: id, data: signupRequest) { (identify, error) in
                
                if let error = error {
                    identifyOffline.identify(id: id, params: signupRequest, reference: nil, send: false)
                    DTLogger.error(error.localizedDescription)
                } else {
                    if let reference = identify?.reference {
                        identifyOffline.identify(id: id, params: signupRequest, reference: reference, send: true)
                        DTLogger.information("Identify realizado")
                    } else {
                        identifyOffline.identify(id: id, params: signupRequest, reference: nil, send: false)
                    }
                }
            }
        }
    }
}
