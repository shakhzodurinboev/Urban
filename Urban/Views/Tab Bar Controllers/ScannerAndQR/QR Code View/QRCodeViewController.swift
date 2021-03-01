//
//  QRCodeViewController.swift
//  Urban
//
//  Created by Khusan on 11.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class QRCodeViewController: QRCodeViewControllerFuncs {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var QRImage: UIImageView!
    @IBOutlet weak var QRCodeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.QRImage.isHidden = true
        self.QRCodeText.isHidden = true
        getUserInfo { (connected) -> (Void) in
            if connected == true {
                self.QRImage.image = self.generateQRCode(from: self.qrcode)
                self.activityIndicator.stopAnimating()
                self.QRImage.isHidden = false
                self.QRCodeText.isHidden = false
            } else {
                if let qrcode = UserDefaults.standard.object(forKey: "qrcode") {
                    self.QRImage.image = self.generateQRCode(from: qrcode as! String)
                    self.activityIndicator.stopAnimating()
                    self.QRImage.isHidden = false
                    self.QRCodeText.isHidden = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.noInternetConnection()
                }
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            guard let qrCodeImage = filter.outputImage else { return nil }
            let scaleX = QRImage.frame.size.width / qrCodeImage.extent.size.width
            let scaleY = QRImage.frame.size.height / qrCodeImage.extent.size.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    func alertView(title: String, message: String) {
        let notification = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        notification.addAction(UIAlertAction(title: NSLocalizedString("Продолжить", comment: "Продолжить"), style: UIAlertAction.Style.destructive, handler: nil))
        self.present(notification, animated: true, completion: nil)
    }
    
    func noInternetConnection() {
        alertView(title: NSLocalizedString("Ошибка соединения с сервером", comment: "Ошибка соединения с сервером"), message: NSLocalizedString("Повторите попытку позже", comment: "Повторите попытку позже"))
    }
}
