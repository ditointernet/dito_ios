//
//  Identify.swift
//  DitoSDK
//
//  Created by Willian Junior Peres De Pinho on 22/12/20.
//

import Foundation

class DTIdentify {
    
    private lazy var service = DTIdentifyService()
    
    func identify(credentials: DTCredentials, data: DTUser) {
        
        let sigunpRequest = DTSignupRequest(platformApiKey: DTInitialize.apiKey,
                                            sha1Signature: DTInitialize.signature,
                                            userData: data)
                
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
