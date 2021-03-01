//
//  DidScannedViewController.swift
//  Urban
//
//  Created by Khusan on 07.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class ProductViewController: ProductViewControllerFuncs {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productPriceWithoutSaleText: UILabel!
    @IBOutlet weak var productPriceWithoutSalePrice: UILabel!
    @IBOutlet weak var scannedImageView: UIImageView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var productTypeWithSaleText: UILabel!
    @IBOutlet weak var productTypeWithSalePrice: UILabel!
    
    var scannedImage: UIImage?
    var barcode = String()
    
    @IBAction func nextButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "nextSegue", sender: self)
    }
    
    @IBAction func fromCBButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "chashbackSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chashbackSegue" {
            let vc = segue.destination as! CashbackViewController
            vc.allData = self.allData
            vc.scannedImage = self.scannedImage
        } else {
            let vc = segue.destination as! ReceiptViewController
            vc.allData = self.allData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        activityIndicator.startAnimating()
        scrollView.isHidden = true
        nextButton.isEnabled = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        getBarcodeInfo(code: barcode) { (connected) -> (Void) in
            if connected == true {
                if self.success == true {
                    self.productName.text = self.allData["productNameData"]!.uppercased()
                    self.productType.text = "\(String(describing: self.allData["productTypeData"]!)), \(String(describing: self.allData["productColorData"]!.lowercased())), \(String(describing: self.allData["productSizeData"]!)), \(String(describing: self.allData["productArticulData"]!.uppercased()))"
                    self.productPriceWithoutSalePrice.text = "\(self.allData["priceData"]!) сум"
                    self.productTypeWithSalePrice.text = self.allData["percentPriceData"]!
                    self.percentLabel.text = "\(self.allData["percentData"]!)%"
                    self.scrollView.isHidden = false
                    self.nextButton.isEnabled = true
                } else {
                    self.alertView(title: NSLocalizedString("Не верный баркод", comment: "Не верный баркод"), message: "")
                }
            } else {
                self.noInternetConnection()
            }
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func initial() {
        if self.scannedImage != nil {
            self.scannedImageView.image = self.scannedImage
        }
    }
    
    func alertView(title: String, message: String) {
        let notification = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        notification.addAction(UIAlertAction(title: NSLocalizedString("Продолжить", comment: "Продолжить"), style: UIAlertAction.Style.destructive)
            { (action:UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }
        )
        self.present(notification, animated: true, completion: nil)
    }
    
    func noInternetConnection() {
        alertView(title: NSLocalizedString("Ошибка соединения с сервером", comment: "Ошибка соединения с сервером"), message: NSLocalizedString("Повторите попытку позже", comment: "Повторите попытку позже"))
    }
}
