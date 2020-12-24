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
        
        let dtIdentify = DTIdentify()
        dtIdentify.helloWorld(log: "Hello")
        
    }
}

