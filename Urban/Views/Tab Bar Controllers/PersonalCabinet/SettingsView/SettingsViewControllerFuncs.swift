//
//  SettingsViewControllerFuncs.swift
//  Urban
//
//  Created by Khusan on 03.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsViewControllerFuncs: UIViewController {

    var success = Bool()
    
    func changeFunc(token: String, name: String, lastname: String, photo: String, gender: String, birthday: String, notice: Int, lang: String, connected:@escaping (Bool) -> ()) {
        let parameters: Parameters = [
            "action" : "MAuth",
            "method" : "update",
            "data" : [
                [
                    "token" : token,
                    "name" : name,
                    "last_name": lastname,
                    "photo" : photo,
                    "gender" : gender,
                    "birthday" : birthday,
                    "notice" : notice,
                    "lang" : lang
                ]
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
            self.success = json["result"]["success"].boolValue
            let data = json["result"]["data"]
            UserDefaults.standard.set(data["token"].stringValue, forKey: "UsersToken")
            UserDefaults.standard.synchronize()
            connected(true)
        })
    }

    func uploadPhoto(lang: String, image: UIImage, onComplete:@escaping((Bool)->())) {
        
        let imgData = image.jpegData(compressionQuality: 0.2)
        let path = "http://94.158.54.150/api/photo/upload"
        let parameters: Parameters = [:]
        let headers: HTTPHeaders = [
            "lang" : UserDefaults.standard.object(forKey: "AppLang") as! String,
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
                        onComplete(true)
                    } else {
                        onComplete(false)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                onComplete(false)
            }
        }
    }
    
}
