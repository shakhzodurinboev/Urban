//
//  BrandsViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 05.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BrandsViewControllerFuncs: UIViewController {
    
    var totalCount = Int()
    var pictureURL = [[String]]()
    var link = [String]()
    
    func getBrands(connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MBrand",
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
            self.totalCount = json["result"]["totalCount"].intValue
            self.pictureURL = json["result"]["data"].arrayValue.map({$0["PICTURE"].arrayObject}) as! [[String]]
            self.link = json["result"]["data"].arrayValue.map({$0["LINK"].stringValue})
            
            UserDefaults.standard.set(self.totalCount, forKey: "brandsTotalCount")
            UserDefaults.standard.set(self.pictureURL, forKey: "brandspictureURL")
            UserDefaults.standard.set(self.link, forKey: "brandslink")
            
            connected(true)
        })
    }

}
