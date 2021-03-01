//
//  PersonalCabinetViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 02.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PersonalCabinetViewControllerFuncs: UIViewController {

    var name = String()
    var surname = String()
    var phone = String()
    var photo = String()
    var gender = String()
    var birthday = String()
    ////////Sale
    var saleMinSumData = String()
    var saleMaxSumData = String()
    var saleMinPerData = String()
    var saleMaxPerData = String()
    var salePerData = String()
    var saleSumData = String()
    ////////Cashback
    var cashSumData = String()
    var cashMaxSumData = String()
    ////////Info
    var saleInfo = String()
    var cashbackInfo = String()
    var cashbackStatus = Int()
    
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
            self.name = data["name"].stringValue
            self.surname = data["last_name"].stringValue
            self.photo = data["photo"].stringValue
            self.phone = data["phone"].stringValue
            self.gender = data["gender"].stringValue
            self.birthday = data["birthday"].stringValue
            ///////Sale
            let sale = data["sale"]
            self.saleMinSumData = sale["min"].stringValue
            self.saleMinPerData = sale["prev_percent"].stringValue
            self.saleMaxPerData = sale["next_percent"].stringValue
            self.salePerData = sale["percent"].stringValue
            self.saleSumData = sale["sum"].stringValue
            self.saleMaxSumData = sale["max"].stringValue
            ///////Cashback
            let cash = data["cashback"]
            self.cashSumData = cash["sum"].stringValue
            self.cashMaxSumData = cash["max"].stringValue
            connected(true)
        })
    }
    
    func getInfo(method: String, connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MInfo",
            "method" : method,
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
            if method == "sale" {
                self.saleInfo = data["TEXT"].stringValue
                UserDefaults.standard.set(self.saleInfo, forKey: "saleInfoInPersonalCab")
            } else {
                self.cashbackInfo = data["TEXT"].stringValue
                self.cashbackStatus = data["description"].intValue
                UserDefaults.standard.set(data["TEXT"].stringValue, forKey: "cashInfoInPersonalCab")
                UserDefaults.standard.set(data["description"].intValue, forKey: "cashStatusInPersonalCab")
            }
            connected(true)
        })
    }
}
