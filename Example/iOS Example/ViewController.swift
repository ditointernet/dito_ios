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
    
    private var birthday: Date? {
        
        let birthdayString = "16/06/1994"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: birthdayString)
    }

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
        
        let json = ["result": "teste", "age": "15", "data": "teste teste"]
                
        let user = DTUser(name: "Rodrigo Maciel",
                          gender: .masculino,
                          email: "teste@teste.com.br",
                          birthday: birthday,
                          location: "São Paulo",
                          createdAt: Date(),
                          json: json)
        DTInitialize.identify(credentials: credentials, data: user)
    }
    
    func setupTrack() {
        
        let json = ["cor": "Azul"]
        
        let event = DTEvent(action: "track-app",
                            json: json)
        
        DTInitialize.track(credentials: credentials, event: event)
    }
}

