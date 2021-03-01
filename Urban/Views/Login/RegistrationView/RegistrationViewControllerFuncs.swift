//
//  RegistrationViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 30.12.2017.
//  Copyright © 2017 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegistrationViewControllerFuncs: UIViewController {

    var success = Bool()
    
    func regFunc(token: String, name: String, lastname: String, gender: String, birthday: String, notice: Int, connected: @escaping(Bool)->()) {
        let parameters: Parameters = [
            "action" : "MAuth",
            "method" : "update",
            "data" : [
                [
                "token" : token,
                "name" : name,
                "last_name": lastname,
                "gender" : gender,
                "birthday" : birthday,
                "notice" : notice
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
            self.success = json["result"]["success"].boolValue
            connected(true)
        })
    }
    
    func uploadPhoto(image: UIImage, notConnected:@escaping (()->()), connected:@escaping (()->())) {
        
        let imgData = image.jpegData(compressionQuality: 0.2)
        let path = "http://api.smarttoys.uz/api/photo/upload"
        
        let parameters: Parameters = [:]
        
        let headers: HTTPHeaders = [
            "lang" : "ru",
            "token" : UserDefaults.standard.object(forKey: "UsersToken") as! String
        ]
        
        let URL = try! URLRequest(url: path, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData!, withName: "profilePhoto",fileName: "profilePhoto.jpg", mimeType: "profilePhoto")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if let value = response.result.value {
                        let json = JSON(value)
                        _ = json["data"]["data"]
                        connected()
                    } else {
                        notConnected()
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                notConnected()
            }
        }
    }
}
