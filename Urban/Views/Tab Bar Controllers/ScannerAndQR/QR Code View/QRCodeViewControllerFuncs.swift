//
//  QRCodeViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 11.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class QRCodeViewControllerFuncs: UIViewController {

    var qrcode = String()
    
    func getUserInfo(connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MAuth",
            "method" : "getuserinfo",
            "data" : [],
            "type" : "rpc"
        ]
        let headers: HTTPHeaders = [
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String,
            "token" : UserDefaults.standard.object(forKey: "UsersToken") as! String
        ]
        AlamofireResponse.shared.getJSON(parameter: parameters, headers: headers, notConnected: { (json) -> (Void) in
            connected(false)
        }, connected: { (json) -> (Void) in
            print(json)
            let data = json["result"]["data"]
            self.qrcode = data["qrcode"].stringValue
            UserDefaults.standard.set(data["cashback"]["sum"].stringValue, forKey: "cashSumData")
            UserDefaults.standard.set(data["qrcode"].stringValue, forKey: "qrcode")
            connected(true)
        })
    }

}
