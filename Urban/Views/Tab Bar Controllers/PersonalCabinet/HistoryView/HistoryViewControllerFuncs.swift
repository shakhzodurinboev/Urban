//
//  HistoryViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 02.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewControllerFuncs: UIViewController {
    
    var paymentCashback = [String]()
    var productType = [String]()
    var paymentCart = [String]()
    var paymentCartName = [String]()
    var filial = [String]()
    var productColor = [String]()
    var productSize = [String]()
    var date = [String]()
    var cashback = [String]()
    var paymentCash = [String]()
    var amount = [String]()
    var productName = [String]()
    var productArticul = [String]()
    var chequeNumber = [String]()
    
    func historyInfo(connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MPursache",
            "method" : "index",
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
            self.paymentCashback = json["result"]["data"].arrayValue.map({$0["PAYMENT_CASHBACK"].stringValue})
            self.productType = json["result"]["data"].arrayValue.map({$0["PRODUCT_TYPE"].stringValue})
            self.paymentCart = json["result"]["data"].arrayValue.map({$0["PAYMENT_CART"].stringValue})
            self.paymentCartName = json["result"]["data"].arrayValue.map({$0["PAYMENT_CART_NAME"].stringValue})
            self.filial = json["result"]["data"].arrayValue.map({$0["FILIAL"].stringValue})
            self.productColor = json["result"]["data"].arrayValue.map({$0["PRODUCT_COLOR"].stringValue})
            self.productSize = json["result"]["data"].arrayValue.map({$0["PRODUCT_SIZE"].stringValue})
            self.date = json["result"]["data"].arrayValue.map({$0["DATE"].stringValue})
            self.cashback = json["result"]["data"].arrayValue.map({$0["CASHBACK"].stringValue})
            self.paymentCash = json["result"]["data"].arrayValue.map({$0["PAYMENT_CASH"].stringValue})
            self.amount = json["result"]["data"].arrayValue.map({$0["AMOUNT"].stringValue})
            self.productName = json["result"]["data"].arrayValue.map({$0["PRODUCT_NAME"].stringValue})
            self.productArticul = json["result"]["data"].arrayValue.map({$0["PRODUCT_ARTICUL"].stringValue})
            self.chequeNumber = json["result"]["data"].arrayValue.map({$0["CHECK"].stringValue})
            
            UserDefaults.standard.set(self.paymentCashback, forKey: "paymentCashbackInHistory")
            UserDefaults.standard.set(self.productType, forKey: "productTypeInHistory")
            UserDefaults.standard.set(self.paymentCart, forKey: "paymentCartInHistory")
            UserDefaults.standard.set(self.paymentCartName, forKey: "paymentCartNameInHistory")
            UserDefaults.standard.set(self.filial, forKey: "filialInHistory")
            UserDefaults.standard.set(self.productColor, forKey: "productColorInHistory")
            UserDefaults.standard.set(self.productSize, forKey: "productSizeInHistory")
            UserDefaults.standard.set(self.date, forKey: "dateInHistory")
            UserDefaults.standard.set(self.cashback, forKey: "cashbackInHistory")
            UserDefaults.standard.set(self.paymentCash, forKey: "paymentCashInHistory")
            UserDefaults.standard.set(self.amount, forKey: "amountInHistory")
            UserDefaults.standard.set(self.productName, forKey: "productNameInHistory")
            UserDefaults.standard.set(self.productArticul, forKey: "productArticulInHistory")
            UserDefaults.standard.set(self.chequeNumber, forKey: "productChequeNumber")
            
            connected(true)
        })
    }
    
    func searchData(name: String, connected:@escaping (Bool) -> (Void)) {
        let parameters: Parameters = [
            "action" : "MPursache",
            "method" : "search",
            "data" : [
                ["name": name]
            ],
            "type" : "rpc"
        ]
        let headers: HTTPHeaders = [
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String,
            "token" : UserDefaults.standard.object(forKey: "UsersToken") as! String
        ]
        AlamofireResponse.shared.getJSON(parameter: parameters, headers: headers, notConnected: { (json) -> (Void) in
            connected(false)
        }, connected: { (json) -> (Void) in
            self.paymentCashback = json["result"]["data"].arrayValue.map({$0["PAYMENT_CASHBACK"].stringValue})
            self.productType = json["result"]["data"].arrayValue.map({$0["PRODUCT_TYPE"].stringValue})
            self.paymentCart = json["result"]["data"].arrayValue.map({$0["PAYMENT_CART"].stringValue})
            self.paymentCartName = json["result"]["data"].arrayValue.map({$0["PAYMENT_CART_NAME"].stringValue})
            self.filial = json["result"]["data"].arrayValue.map({$0["FILIAL"].stringValue})
            self.productColor = json["result"]["data"].arrayValue.map({$0["PRODUCT_COLOR"].stringValue})
            self.productSize = json["result"]["data"].arrayValue.map({$0["PRODUCT_SIZE"].stringValue})
            self.date = json["result"]["data"].arrayValue.map({$0["DATE"].stringValue})
            self.cashback = json["result"]["data"].arrayValue.map({$0["CASHBACK"].stringValue})
            self.paymentCash = json["result"]["data"].arrayValue.map({$0["PAYMENT_CASH"].stringValue})
            self.amount = json["result"]["data"].arrayValue.map({$0["AMOUNT"].stringValue})
            self.productName = json["result"]["data"].arrayValue.map({$0["PRODUCT_NAME"].stringValue})
            self.productArticul = json["result"]["data"].arrayValue.map({$0["PRODUCT_ARTICUL"].stringValue})
            connected(true)
        })
    }
    
}
