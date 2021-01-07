//
//  String+Extension.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 23/12/20.
//

import Foundation
import CryptoKit

//MARK: PUBLIC
extension String {
    
    var sha1: String {
        guard #available(iOS 13, *) else {
            return SHA1.hexString(from: self)?
                .lowercased()
                .replacingOccurrences(of: " ", with: "") ?? ""
        }
        
        return Insecure.SHA1.hash(data: self.data(using: .utf8) ?? Data())
            .map {
                String(format: "%02hhx", $0)
            }.joined()
    }
    
    var formatToDitoString: String {
        Util.keywordVerification(self.checkCharacters)
        return self.replacingElements
    }
}

//MARK: PRIVATE
extension String {
    
    private var ignoreAccentuation: String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    private var containsUppercase: Bool {
        let uppercaseRegEx = ".*[A-Z]+.*"
        return NSPredicate(format:"SELF MATCHES %@", uppercaseRegEx).evaluate(with: self)
    }
    
    private var containsNumber: Bool {
        let numberRegEx = ".*[0-9]+.*"
        return NSPredicate(format:"SELF MATCHES %@", numberRegEx).evaluate(with: self)
    }
    
    private var containsSpecialCharacters: Bool {
        let specialRegEx = ".*[)(,.#?!@$%^&<>*~:`]+.*"
        return NSPredicate(format:"SELF MATCHES %@", specialRegEx).evaluate(with: self)
    }
    
    private var containsWhiteSpace: Bool {
        return self.contains(" ")
    }
    
    private var containsAccentuation: Bool {
        return self != self.ignoreAccentuation
    }
    
    private var checkCharacters: [DTValidationCharacters] {
        
        var containsCharacters: [DTValidationCharacters] = []
        
        if self.containsUppercase {
            containsCharacters.append(.uppercase)
        }
        
        if self.containsNumber {
            containsCharacters.append(.number)
        }
        
        if self.containsSpecialCharacters {
            containsCharacters.append(.special)
        }
        
        if self.containsWhiteSpace {
            containsCharacters.append(.whiteSpace)
        }
        
        if self.containsAccentuation {
            containsCharacters.append(.accentuation)
        }
        
        return containsCharacters
    }
    
    private var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ-")
        return self.filter {okayChars.contains($0) }
    }
    
    private var replacingElements: String {
        
        return self.replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "--", with: "-")
            .lowercased()
            .ignoreAccentuation
            .stripped
    }
}
