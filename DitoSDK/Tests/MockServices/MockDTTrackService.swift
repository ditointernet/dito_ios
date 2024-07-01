//
//  MockDTTrackService.swift
//  DitoSDK Tests
//
//  Created by brennobemoura on 07/01/21.
//

@testable import DitoSDK

class MockDTTrackService: DitoTrackService {
    var resultHandler: ((Error?) -> Void)?
    
    func onResult(_ resultHandler: @escaping (Error?) -> Void) {
        self.resultHandler = resultHandler
    }
    
    override func request<T>(type: T.Type, router: DitoRouterService, completion: @escaping NetworkCompletion<T>) where T : Decodable {
        super.request(type: type, router: router) { [resultHandler] in
            if case .failure(let error) = $0 {
                resultHandler?(error)
                return
            }
            
            resultHandler?(nil)
        }
    }
}
