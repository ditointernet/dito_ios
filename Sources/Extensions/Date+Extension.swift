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
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss -z"
        return dateFormatter.string(from: currentDateTime)
     }
}
