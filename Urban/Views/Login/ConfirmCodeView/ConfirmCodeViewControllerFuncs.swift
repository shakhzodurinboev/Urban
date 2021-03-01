//
//  ConfirmCodeViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 29.12.2017.
//  Copyright © 2017 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConfirmCodeViewControllerFuncs: UIViewController {
    
    var error = String()
    var isActivated = Int()
    
    func confirmCode(phone: String, code: Int, connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MAuth",
            "method" : "login",
            "data" : [
                ["phone" : phone,
                    "code": code
                ]
            ],
            "type" : "rpc"
        ]
        let headers: HTTPHeaders = [
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String
        ]
        AlamofireResponse.shared.getJSON(parameter: parameters, headers: headers, notConnected: { (json) -> (Void) in
            connected(false)
        }, connected: { (json) -> (Void) in
            print(json)
            self.error = json["result"]["error"].stringValue
            if self.error == "Incorrect code" {
                connected(false)
            } else {
                let data = json["result"]["data"]
                UserDefaults.standard.set(data["token"].stringValue, forKey: "UsersToken") 
                self.isActivated = data["activated"].intValue
                connected(true)
            }
        })
    }
    
    func takeCode(phoneNumber: String, connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MAuth",
            "method" : "auth",
            "data" :[
                ["phone" : phoneNumber]
            ],
            "type" : "rpc"
        ]
        let headers: HTTPHeaders = [
            "lang" : "ru"
        ]
        AlamofireResponse.shared.getJSON(parameter: parameters, headers: headers, notConnected: { (json) -> (Void) in
            connected(false)
        }, connected: { (json) -> (Void) in
            print(json)
            let result = json["result"]["success"].boolValue
            if result == true {
                connected(true)
            } else {
                connected(false)
            }
        })
    }
}
