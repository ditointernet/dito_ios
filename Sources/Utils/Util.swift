//
//  Util.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 04/01/21.
//

import Foundation


class Util {
    
    static func toString(from json: Any?) -> String? {
        
        guard let json = json else { return nil }
        
        do {
            let data =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        
        } catch let error {
            DTLogger.error(error)
            return nil
        }
    }
    
    static func keywordVerification(_ containsCharacters: [DTValidationCharacters]) {
        
        var warning: String = ""
        
        containsCharacters.forEach{
            switch $0 {
            case .uppercase:
                warning += "Sua palavra chave contém letra maiúscula\n"
            case .accentuation:
                warning += "Sua palavra chave contém acentuação\n"
            case .whiteSpace:
                warning += "Sua palavra chave contém espaço em branco\n"
            case .special:
                warning += "Sua palavra chave contém caractere especial\n"
            case .number:
                warning += "Sua palavra chave contém número\n"
            }
        }
        
        if !warning.isEmpty {
            DTLogger.warning(warning)
        }
    }
    
    static func validateEmail(_ isValidEmail: Bool) {
        
        if !isValidEmail {
            DTLogger.warning("DTUser - e-mail inserido é inválido")
        }
    }
}
