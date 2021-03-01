//
//  LoginViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 29.12.2017.
//  Copyright © 2017 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewControllerFuncs: UIViewController {
    
    var offerInfo = String()
    
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
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String
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
    
    func getInfo(connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MInfo",
            "method" : "offer",
            "type" : "rpc"
        ]
        let headers: HTTPHeaders = [
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String
        ]
        AlamofireResponse.shared.getJSON(parameter: parameters, headers: headers, notConnected: { (json) -> (Void) in
            connected(false)
        }, connected: { (json) -> (Void) in
            let data = json["result"]["data"]
            self.offerInfo = data["TEXT"].stringValue
            UserDefaults.standard.set(self.offerInfo, forKey: "offerInfo")
            connected(true)
        })
    }
}
