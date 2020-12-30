//
//  ViewController.swift
//  DitoSwiftSampleApp
//
//  Created by Willian Junior Peres De Pinho on 22/12/20.
//

import UIKit
import DitoSDK

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        DTInitialize.configure(apiKey: "MjAxOS0wMi0wNyAxNDo1Mzo0OCAtMDIwMFRlc3RlIC0gSUI2NDE",
                               apiSecret: "xcaoI1lXnyraH1MCQtRPkbUOAqAS6ywikNGQTiZw")
                
        let credentials = DTCredentials(id: "1020")
        let user = DTUser(name: "Rodrigo Maciel", gender: .masculino, email: "rodrigomaciel@ioasys.com.br", data: "[ {\"name\": \"John\", \"age\": 21}, {\"name\": \"Bob\", \"age\": 35} ]")
        DTInitialize.identify(credentials: credentials, data: user)
    }
}

