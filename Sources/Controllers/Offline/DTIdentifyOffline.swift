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
        
        #warning("save data to database")
    
        
        /**

        - Parameter id: String
        - Parameter json: String
        - Parameter reference: String or nil
        - Parameter send: Boolean
       
        */
                
    }
}
