//
//  DTTrackOffline.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 13/01/21.
//

import Foundation
import CoreData

struct DTTrackOffline {
    
    private var trackDataManager: DTTrackDataManager
    private let identifyOffline: DTIdentifyOffline
    
    init(trackDataManager: DTTrackDataManager = .init(), identifyOffline: DTIdentifyOffline = .init()) {
        self.trackDataManager = trackDataManager
        self.identifyOffline = identifyOffline
    }
    
    func track(event: DTEventRequest) {
        DispatchQueue.global().async {
            let json = event.toString
            trackDataManager.save(event: json, retry: 1)
        }
    }
    
    var reference: String? {
        return identifyOffline.getIdentify?.reference
    }
    
    var getTrack: [Track] {
        return trackDataManager.fetchAll
    }
    
    func update(id: NSManagedObjectID, event: DTEventRequest, retry: Int16) {
        let json = event.toString
        trackDataManager.update(id: id, event: json, retry: retry)
    }
    
    func delete(id: NSManagedObjectID) {
        trackDataManager.delete(with: id)
    }
}
