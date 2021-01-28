//
//  DitoNotificationService.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 27/01/21.
//

import Foundation

class DitoNotificationService: DitoServiceManager {
    
    func register(reference: String, data: DitoTokenRequest, completion: @escaping (_ success: DitoTokenModel?, _ error: Error?) -> ()) {
        
        request(type: DitoTokenModel.self, router: .register(reference: reference, data: data)) { result in
            
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func unregister(reference: String, data: DitoTokenRequest, completion: @escaping (_ success: DitoTokenModel?, _ error: Error?) -> ()) {
        
        request(type: DitoTokenModel.self, router: .unregister(reference: reference, data: data)) { result in
            
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func read(reference: String, data: DitoNotificationOpenRequest, completion: @escaping (_ success: DitoIdentifyModel?, _ error: Error?) -> ()) {
        
        request(type: DitoIdentifyModel.self, router: .open(reference: reference, data: data)) { result in
            
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
