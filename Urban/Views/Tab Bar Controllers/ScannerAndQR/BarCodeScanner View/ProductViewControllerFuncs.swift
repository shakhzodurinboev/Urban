//
//  DidScannedViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 07.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductViewControllerFuncs: UIViewController {
    
    var success = Bool()
    var allData = [String : String]()
    
    func getBarcodeInfo(code: String, connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MPursache",
            "method" : "show",
            "data" : [
                ["id" : code]
            ],
            "type" : "rpc"
        ]
        let headers: HTTPHeaders = [
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String,
            "token" : UserDefaults.standard.object(forKey: "UsersToken") as! String
        ]
        print("Parameters: \(parameters)")
        print("Headers: \(headers)")
        AlamofireResponse.shared.getJSON(parameter: parameters, headers: headers, notConnected: { (json) -> (Void) in
            print(json)
            connected(false)
        }, connected: { (json) -> (Void) in
            print(json)
            let data = json["result"]["data"]
            if json["result"]["success"].boolValue == true {
                self.success = json["result"]["success"].boolValue
                self.allData = ["productSizeData":"\(data[0]["PRODUCT_SIZE"].stringValue)", "percentPriceData":"\(data[0]["PERCENT_PRICE"].stringValue)", "productIdData":"\(data[0]["ID"].stringValue)", "productNameData":"\(data[0]["PRODUCT_NAME"].stringValue)", "percentData":"\(data[0]["PERCENT"].stringValue)", "cashbackData":"\(data[0]["CASHBACK"].stringValue)", "priceData":"\(data[0]["PRICE"].stringValue)", "productArticulData":"\(data[0]["PRODUCT_ARTICUL"].stringValue)", "productTypeData":"\(data[0]["PRODUCT_TYPE"].stringValue)", "productColorData":"\(data[0]["PRODUCT_COLOR"].stringValue)"]
            } else {
                self.success = json["result"]["success"].boolValue
            }
            connected(true)
        })
    }
    
}
