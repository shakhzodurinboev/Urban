//
//  MapViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 05.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MapViewControllerFuncs: UIViewController {
    
    var totalCount = Int()
    static var lattitude = [String]()
    static var longtitude = [String]()
    static var address = [String]()
    static var name = [String]()
    static var phoneNumber = [String]()
    static var monTime = [JSON]()
    
    func getFilials(connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MFilial",
            "method" : "index",
            "data" : [],
            "type" : "rpc"
        ]
        let headers: HTTPHeaders = [
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String
        ]
        AlamofireResponse.shared.getJSON(parameter: parameters, headers: headers, notConnected: { (json) -> (Void) in
            print(json)
            connected(false)
        }, connected: { (json) -> (Void) in
            self.totalCount = json["result"]["data"].arrayValue.map({$0["LAT"]}).count
            MapViewControllerFuncs.lattitude = json["result"]["data"].arrayValue.map({$0["LAT"].stringValue})
            MapViewControllerFuncs.longtitude = json["result"]["data"].arrayValue.map({$0["LON"].stringValue})
            MapViewControllerFuncs.address = json["result"]["data"].arrayValue.map({$0["ADDRESS"].stringValue})
            MapViewControllerFuncs.name = json["result"]["data"].arrayValue.map({$0["NAME"].stringValue})
            MapViewControllerFuncs.phoneNumber = json["result"]["data"].arrayValue.map({$0["PHONE"].stringValue})
            MapViewControllerFuncs.monTime = json["result"]["data"].arrayValue.map({$0["WORK_TIME"][0]})
            connected(true)
        })
    }
    
}
