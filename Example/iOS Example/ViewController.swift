//
//  ViewController.swift
//  DitoSwiftSampleApp
//
//  Created by Willian Junior Peres De Pinho on 22/12/20.
//

import UIKit
import DitoSDK

class ViewController: UIViewController {
    
    private var birthday: Date? {
        
        let birthdayString = "16/06/1994"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: birthdayString)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapIdentify(_ sender: Any) {
        setupIdentify()
    }
    
    @IBAction func didTapTrack(_ sender: Any) {
        setupTrack()
    }
}

extension ViewController {
    
    private func setupIdentify() {
        
        let json = ["carro": "celta", "cor": "preto"]
                
        let user = DTUser(name: "Rodrigo Maciel",
                          gender: .masculino,
                          email: "teste@teste.com.br",
                          birthday: birthday,
                          location: "São Paulo",
                          json: json)
        Dito.identify(id: "1021", data: user)
    }
    
    private func setupTrack() {
        
        let event = DTEvent(action: "botao-comprar-produtos")
        
        Dito.track(event: event)
    }
}
