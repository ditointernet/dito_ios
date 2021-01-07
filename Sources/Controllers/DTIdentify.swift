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
    
    func identify(credentials: DTCredentials,
                  data: DTUser,
                  sha1Signature: String = DTInitialize.signature) {
        
        let sigunpRequest = DTSignupRequest(platformApiKey: DTInitialize.apiKey,
                                            sha1Signature: sha1Signature,
                                            userData: data)
                
        guard data.email != nil else {
            return
        }
        service.signup(network: "portal", id: credentials.id, data: sigunpRequest) { (identify, error) in
            
            if let error = error {
                DTLogger.error(error.localizedDescription)
            } else {
                UserDefaults.reference = identify?.reference ?? ""
                DTLogger.information("Identify realizado")
            }
        }
    }
}
