//
//  DTRetry.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 14/01/21.
//

import Foundation


struct DitoRetry {
    
    private var identifyOffline: DTIdentifyOffline
    private var trackOffline: DTTrackOffline
    private let serviceIdentify: DTIdentifyService
    private let serviceTrack: DTTrackService
    
    init(identifyOffline: DTIdentifyOffline = .init(), trackOffline: DTTrackOffline = .init(),
         serviceIdentify: DTIdentifyService = .init(), serviceTrack: DTTrackService = .init()) {
        
        self.identifyOffline = identifyOffline
        self.trackOffline = trackOffline
        self.serviceIdentify = serviceIdentify
        self.serviceTrack = serviceTrack
    }
    
    func loadOffline() {
        
        checkIdentify()
        checkTrack()
    }
    
    private func checkIdentify() {
        DispatchQueue.global().async {
            
            guard let identify = identifyOffline.getIdentify,
                  let id = identify.id,
                  let signupRequest = identify.json?.convertToObject(type: DTSignupRequest.self) else { return }
            
            if !identify.send {
                
                serviceIdentify.signup(network: "portal", id: id, data: signupRequest) { (identify, error) in
                    
                    if let error = error {
                        DTLogger.error(error.localizedDescription)
                    } else {
                        if let reference = identify?.reference {
                            identifyOffline.update(id: id, params: signupRequest, reference: reference, send: true)
                            DTLogger.information("Identify realizado")
                        }
                    }
                }
            }
        }
    }
    
    private func checkTrack(retry: Int = 5) {
        DispatchQueue.global().async {
            
            let tracks = trackOffline.getTrack
            
            tracks.forEach { track in

                if track.retry == retry {
                    trackOffline.delete(id: track.objectID)
                } else {
                    sendEvent(track: track)
                }
            }
        }
    }
    
    private func sendEvent(track: Track) {
        
        guard let event = track.event, let eventRequest = event.convertToObject(type: DTEventRequest.self) else { return }
        let id = track.objectID
        
        if let reference = trackOffline.reference, !reference.isEmpty {
            serviceTrack.event(reference: reference, data: eventRequest) { (_, error) in
                
                if let error = error {
                    trackOffline.update(id: id, event: eventRequest, retry: track.retry + 1)
                    DTLogger.error(error.localizedDescription)
                } else {
                    trackOffline.delete(id: id)
                    DTLogger.information("Track - Evento enviado")
                }
            }
        } else {
            trackOffline.update(id: id, event: eventRequest, retry: track.retry + 1)
            DTLogger.warning("Track - Antes de enviar um evento é preciso identificar o usuário.")
        }
    }
}
