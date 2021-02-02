//
//  DTTrackOffline.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 13/01/21.
//

import Foundation
import CoreData

struct DitoTrackOffline {
    
    private var trackDataManager: DitoTrackDataManager
    private let identifyOffline: DitoIdentifyOffline
    
    init(trackDataManager: DitoTrackDataManager = .init(), identifyOffline: DitoIdentifyOffline = .init()) {
        self.trackDataManager = trackDataManager
        self.identifyOffline = identifyOffline
    }
    
    func track(event: DitoEventRequest) {
        DispatchQueue.global().async {
            let json = event.toString
            self.trackDataManager.save(event: json)
        }
    }
    
    var reference: String? {
        return identifyOffline.getIdentify?.reference
    }
    
    var getTrack: [Track] {
        return trackDataManager.fetchAll
    }
    
    func update(id: NSManagedObjectID, event: DitoEventRequest, retry: Int16) {
        let json = event.toString
        trackDataManager.update(id: id, event: json, retry: retry)
    }
    
    func delete(id: NSManagedObjectID) {
        trackDataManager.delete(with: id)
    }
}
