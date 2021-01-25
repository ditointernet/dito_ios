//
//  DTTrack.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 24/12/20.
//

import Foundation

struct DitoTrack {

    private let service: DitoTrackService
    private let trackOffline: DitoTrackOffline
    
    init(service: DitoTrackService = .init(), trackOffline: DitoTrackOffline = .init()) {
        self.service = service
        self.trackOffline = trackOffline
    }
    
    func track(data: DitoEvent) {
        
        DispatchQueue.global().async {
            
            let eventRequest = DitoEventRequest(platformApiKey: Dito.apiKey, sha1Signature: Dito.signature, event: data)
            
            if let reference = trackOffline.reference, !reference.isEmpty {
                service.event(reference: reference, data: eventRequest) { (track, error) in
                    
                    if let error = error {
                        trackOffline.track(event: eventRequest)
                        DitoLogger.error(error.localizedDescription)
                    } else {
                        DitoLogger.information("Track - Evento enviado")
                    }
                }
            } else {
                trackOffline.track(event: eventRequest)
                DitoLogger.warning("Track - Antes de enviar um evento é preciso identificar o usuário.")
            }
        }
    }
}
