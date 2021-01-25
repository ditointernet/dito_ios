//
//  Identify.swift
//  DitoSDK
//
//  Created by Willian Junior Peres De Pinho on 22/12/20.
//

import Foundation

struct DitoIdentify {
    
    private let service: DitoIdentifyService
    private let identifyOffline: DitoIdentifyOffline
    
    init(service: DitoIdentifyService = .init(), identifyOffline: DitoIdentifyOffline = .init()) {
        self.service = service
        self.identifyOffline = identifyOffline
    }
    
    func identify(id: String, data: DitoUser, sha1Signature: String = Dito.signature) {
        
        DispatchQueue.global().async {
            
            let signupRequest = DitoSignupRequest(platformApiKey: Dito.apiKey,
                                                sha1Signature: sha1Signature,
                                                userData: data)
            
            guard data.email != nil else {
                return
            }
            service.signup(network: "portal", id: id, data: signupRequest) { (identify, error) in
                
                if let error = error {
                    identifyOffline.identify(id: id, params: signupRequest, reference: nil, send: false)
                    DitoLogger.error(error.localizedDescription)
                } else {
                    if let reference = identify?.reference {
                        identifyOffline.identify(id: id, params: signupRequest, reference: reference, send: true)
                        DitoLogger.information("Identify realizado")
                    } else {
                        identifyOffline.identify(id: id, params: signupRequest, reference: nil, send: false)
                    }
                }
            }
        }
    }
}
