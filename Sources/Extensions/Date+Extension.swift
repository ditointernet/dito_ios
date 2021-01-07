//
//  Date+Extension.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 04/01/21.
//

import Foundation

extension Date {
    
    var formatToISO: String? {
        
        let currentDateTime = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss -z"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: currentDateTime)
     }
    
    var formatToDitoDate: String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let result = dateFormatter.string(from: self)
        return result
     }
}
