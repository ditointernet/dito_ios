//
//  ViewController.swift
//  DitoSwiftSampleApp
//
//  Created by Willian Junior Peres De Pinho on 22/12/20.
//

import UIKit
import DitoSDK

class ViewController: UIViewController {
    
    
    var credentials: DTCredentials!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DTInitialize.configure(apiKey: "MjAxOS0wMi0wNyAxNDo1Mzo0OCAtMDIwMFRlc3RlIC0gSUI2NDE",
                               apiSecret: "xcaoI1lXnyraH1MCQtRPkbUOAqAS6ywikNGQTiZw")
        
        credentials = DTCredentials(id: "1020")

    }
    
    @IBAction func didTapIdentify(_ sender: Any) {
        setupIdentify()
    }
    
    @IBAction func didTapTrack(_ sender: Any) {
        setupTrack()
    }
    
    func setupIdentify() {
        
        
        
        let json = ["result": "teste", "age": "10", "data": "teste data"] as AnyObject
                
    
        let user = DTUser(name: "Rodrigo Maciel",
                          gender: .masculino,
                          email: "teste@teste.com.br",
                          birthday: "16/06/1994",
                          location: "São Paulo",
                          createdAt: Date(),
                          json: json)
        DTInitialize.identify(credentials: credentials, data: user)
    }
    
    func setupTrack() {
        
        let json = ["cor": "Azul"] as AnyObject
        
        let event = DTEvent(action: "botao-track-pressionado",
                            json: json)
        
        DTInitialize.track(credentials: credentials, event: event)
    }
}

