//
//  String+Extension.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 23/12/20.
//

import Foundation
import CryptoKit

extension String {
    
    var sha1: String {
        
        let digest = Insecure.SHA1.hash(data: self.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
