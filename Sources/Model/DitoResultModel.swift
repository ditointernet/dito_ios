//
//  DTResultModel.swift
//  DitoSDK
//
//  Created by Rodrigo Damacena Gamarra Maciel on 30/12/20.
//

import Foundation

struct DitoResultModel<T: Decodable>: Decodable {
    var data: T?
}
