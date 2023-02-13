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
    @IBAction func didTapRegisterDevice(_ sender: Any) {
        registerToken()
    }
    @IBAction func didTapUnregisterDevice(_ sender: Any) {
        unregisterToken()
    }
}

extension ViewController {
    
    private func setupIdentify() {
        
        let customData = ["carro": "celta", "cor": "preto"]
                
        let user = DitoUser(name: "Rodrigo Maciel",
                          gender: .masculino,
                          email: "teste@teste.com.br",
                          birthday: birthday,
                          location: "São Paulo",
                          customData: customData)
        Dito.identify(id: "1021", data: user)
    }
    
    private func setupTrack() {
        
        let event = DitoEvent(action: "botao-comprar-produtos")

        Dito.track(event: event)
    }
    
    private func registerToken() {
    
        Dito.registerDevice(token: notificationToken, tokenType: .apple)
    }
    
    private func unregisterToken() {

        Dito.unregisterDevice(token: notificationToken, tokenType: .apple)
    }
    
    private var notificationToken: String {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let token = appDelegate.token else { return "" }
        
        return token
    }
}
