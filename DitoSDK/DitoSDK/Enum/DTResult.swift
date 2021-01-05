//
//  Result.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 22/12/20.
//


import Foundation

typealias NetworkCompletion<T: Decodable> = (_ result: DTResult<T>)-> Void

enum DTResult<T> {
    case success(data: T)
    case failure(error: DTErrorType)
}
 
