//
//  LaunchViewController.swift
//  Urban
//
//  Created by Khusan Yusufkhujaev on 10/22/18.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBAction func GSlinkButtonAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://www.globalsolutions.uz")!)
    }
    
    @objc func nextScreen() {
        if let userIsLogged = UserDefaults.standard.object(forKey: "UserIsLogged") {
            if userIsLogged as! Bool == true {
                performSegue(withIdentifier: "tabBarSegue", sender: self)
            } else {
                performSegue(withIdentifier: "loginSegue", sender: self)
            }
        } else {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///////Check user is logged or not
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(nextScreen), userInfo: nil, repeats: false)
    }

}
