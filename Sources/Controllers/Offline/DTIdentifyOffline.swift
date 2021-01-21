//
//  DTIdentifyOffline.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 13/01/21.
//

import Foundation


struct DTIdentifyOffline {
    
    private var identifyDataManager: DTIdentifyDataManager
    
    init(identifyDataManager: DTIdentifyDataManager = .init()) {
        self.identifyDataManager = identifyDataManager
    }
    
    
    func identify(id: String, params: DTSignupRequest, reference: String?, send: Bool) {
        DispatchQueue.global().async {
            let json = params.toString
            identifyDataManager.save(id: id, reference: reference, json: json, send: send)
        }
    }
    
    var getIdentify: Identify? {
        return identifyDataManager.fetch
    }
    
    func update(id: String, params: DTSignupRequest, reference: String?, send: Bool) {
        let json = params.toString
        identifyDataManager.update(id: id, reference: reference, json: json, send: send)
        
    }
}
