//
//  DTTrack.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 24/12/20.
//

import Foundation

class DTTrack {

    private let service: DTTrackService
    
    init(service: DTTrackService = .init()) {
        self.service = service
    }
    
    func track(credentials: DTCredentials, data: DTEvent) {
        
        let eventRequest = DTEventRequest(platformApiKey: DTInitialize.apiKey, sha1Signature: DTInitialize.signature, event: data)
        
        let reference = UserDefaults.reference
        
        if !reference.isEmpty {
            service.event(reference: reference, data: eventRequest) { (track, error) in
                
                if let error = error {
                    DTLogger.error(error.localizedDescription)
                } else {
                    DTLogger.information("Evento enviado")
                }
            }
        } else {
            DTLogger.warning("Usuário não foi identificado.")
        }
    }
}
