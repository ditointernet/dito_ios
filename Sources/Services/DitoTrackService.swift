//
//  DTTrackService.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 05/01/21.
//

import Foundation


class DitoTrackService: DitoServiceManager {
    

    func event(reference: String, data: DitoEventRequest, completion: @escaping (_ success: [DitoTrackModel]?, _ error: Error?) -> ()) {
        
        let debugData = data
        let debugReference = reference
        
        request(type: [DitoTrackModel].self, router: .track(reference: reference, data: data)) { result in
            
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
