//
//  NewsViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 07.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsViewControllerFuncs: UIViewController {
    
    var id = Int()
    var labelOfProduct = [String]()
    var nameOfProduct = [String]()
    var descriptionOfProduct = [String]()
    var priceOfProduct = [String]()
    var imgURLOfProduct = [[String]]()
    var videoURLOfProduct = [String]()
    
    func getNews(category: String, connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MFeed",
            "method" : "index",
            "data" : [
                ["category" : category]
            ],
            "type" : "rpc"
        ]
        let headers: HTTPHeaders = [
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String
        ]
        AlamofireResponse.shared.getJSON(parameter: parameters, headers: headers, notConnected: { (json) -> (Void) in
            connected(false)
        }, connected: { (json) -> (Void) in
            self.id = json["result"]["data"].arrayValue.map({$0["ID"].intValue}).count
            self.labelOfProduct = json["result"]["data"].arrayValue.map({$0["LABEL"].stringValue})
            self.nameOfProduct = json["result"]["data"].arrayValue.map({$0["NAME"].stringValue})
            self.descriptionOfProduct = json["result"]["data"].arrayValue.map({$0["DESCRIPTION"].stringValue})
            self.priceOfProduct = json["result"]["data"].arrayValue.map({$0["PRICE"].stringValue})
            self.imgURLOfProduct = json["result"]["data"].arrayValue.map({$0["PICTURE"].arrayObject}) as! [[String]]
            self.videoURLOfProduct = json["result"]["data"].arrayValue.map({$0["VIDEO"].stringValue})
            
            UserDefaults.standard.set(self.id, forKey: "idInNews")
            UserDefaults.standard.set(self.labelOfProduct, forKey: "labelOfProductInNews")
            UserDefaults.standard.set(self.nameOfProduct, forKey: "nameOfProductInNews")
            UserDefaults.standard.set(self.descriptionOfProduct, forKey: "descriptionOfProductInNews")
            UserDefaults.standard.set(self.priceOfProduct, forKey: "priceOfProductInNews")
            UserDefaults.standard.set(self.imgURLOfProduct, forKey: "imgURLOfProductInNews")
            UserDefaults.standard.set(self.videoURLOfProduct, forKey: "videoURLOfProductInNews")
            
            connected(true)
        })
    }
    
}
