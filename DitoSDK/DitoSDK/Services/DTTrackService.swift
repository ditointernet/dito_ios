//
//  DTTrackService.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 05/01/21.
//

import Foundation


class DTTrackService: DTServiceManager {
    

    func event(id: String, data: DTEventRequest, completion: @escaping (_ success: DTTrackModel?, _ error: Error?) -> ()) {
        
        request(type: [DTTrackModel].self, router: .track(id: id, data: data)) { result in
            
            switch result {
            case .success(let data):
                completion(data.first, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
