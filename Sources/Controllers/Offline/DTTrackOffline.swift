//
//  DTTrackOffline.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 13/01/21.
//

import Foundation

struct DTTrackOffline {
    
    private var trackDataManager: DTTrackDataManager
    
    init(trackDataManager: DTTrackDataManager = .init()) {
        self.trackDataManager = trackDataManager
    }
    
    
    func track(event: DTEventRequest) {
        
        #warning("save data to database")
        
        /**
        - Parameter event: String
        - Parameter retry: Int
        */
    }
}
