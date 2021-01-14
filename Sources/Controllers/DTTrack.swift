//
//  DTTrack.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 24/12/20.
//

import Foundation

struct DTTrack {

    private let service: DTTrackService
    
    init(service: DTTrackService = .init()) {
        self.service = service
    }
    
    func track(data: DTEvent) {
        
        DispatchQueue.global().async {
            
            let eventRequest = DTEventRequest(platformApiKey: DTInitialize.apiKey, sha1Signature: DTInitialize.signature, event: data)
            
            let reference = UserDefaults.reference
            
            if !reference.isEmpty {
                service.event(reference: reference, data: eventRequest) { (track, error) in
                    
                    if let error = error {
                        DTLogger.error(error.localizedDescription)
                    } else {
                        DTLogger.information("Track - Evento enviado")
                    }
                }
            } else {
                DTLogger.warning("Track - Antes de enviar um evento é preciso identificar o usuário.")
            }
        }
    }
}
