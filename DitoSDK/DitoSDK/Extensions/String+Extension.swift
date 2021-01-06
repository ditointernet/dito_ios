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
    
    var formatToDitoDate: String? {
        
        let countDigitDate: Int = 10
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let date = dateFormatter.date(from: self), self.count == countDigitDate else {
            #warning("TODO: implement logger")
            print("A data de aniversário não é uma data válida")
            return nil
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
     }
    
}