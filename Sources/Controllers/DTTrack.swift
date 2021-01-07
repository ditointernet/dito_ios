//
//  DTTrack.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 24/12/20.
//

import Foundation

public struct DTTrack {

    private let service: DTTrackService
    
    init(service: DTTrackService = .init()) {
        self.service = service
    }
    
    func track(credentials: DTCredentials, data: DTEvent) {
        
        let eventRequest = DTEventRequest(platformApiKey: DTInitialize.apiKey, sha1Signature: DTInitialize.signature, event: data)

        service.event(id: credentials.id, data: eventRequest) { (track, error) in
            
            if let error = error {
                #warning("TODO: implement logger")
                print(error.localizedDescription)
            } else {
                #warning("TODO: save reference in cache")
                print(track)
            }
        }
    }
    
}
