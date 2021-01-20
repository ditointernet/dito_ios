//
//  DTTrack.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 24/12/20.
//

import Foundation

struct DTTrack {

    private let service: DTTrackService
    private let trackOffline: DTTrackOffline
    
    init(service: DTTrackService = .init(), trackOffline: DTTrackOffline = .init()) {
        self.service = service
        self.trackOffline = trackOffline
    }
    
    func track(data: DTEvent) {
        
        DispatchQueue.global().async {
            
            let eventRequest = DTEventRequest(platformApiKey: DTInitialize.apiKey, sha1Signature: DTInitialize.signature, event: data)
            
            if let reference = trackOffline.reference, !reference.isEmpty {
                service.event(reference: reference, data: eventRequest) { (track, error) in
                    
                    if let error = error {
                        trackOffline.track(event: eventRequest)
                        DTLogger.error(error.localizedDescription)
                    } else {
                        DTLogger.information("Track - Evento enviado")
                    }
                }
            } else {
                trackOffline.track(event: eventRequest)
                DTLogger.warning("Track - Antes de enviar um evento é preciso identificar o usuário.")
            }
        }
    }
}
