//
//  ViewController.swift
//  Dito test sdk
//
//  Created by Igor Duarte on 26/03/24.
//

import UIKit
import DitoSDK
import Toast_Swift
import CoreData
import FirebaseMessaging

class ViewController: UIViewController {
    @IBOutlet weak var fieldCpf: UITextField!
    
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
        handleIndentifyClick(identify: fieldCpf.text ?? "69606629074")
    }
    
    @IBAction func didTapNotification(_ sender: Any) {
        handleNotificationClick()
    }
}

extension ViewController {
    func handleIndentifyClick(identify: String) {
        let user = DitoUser(name: "Dito user teste",
                            gender: .masculino,
                            email: "teste.ios2@dito.com.br",
                            birthday: birthday,
                            location: "Florianópolis")
        Dito.identify(id: identify, data: user)
        self.view.makeToast("Usuário identificado")
    }
    
    func handleNotificationClick() {
        let event = DitoEvent(action: "teste-behavior", customData: ["id_loja": 123] )
        Dito.track(event: event)
        self.view.makeToast("Evento disparado")
    }

}

