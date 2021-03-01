//
//  CashbackViewController.swift
//  Urban
//
//  Created by Khusan on 23.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class CashbackViewController: CashbackViewControllerFuncs, UITextFieldDelegate {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productPriceWithoutSalePrice: UILabel!
    @IBOutlet weak var inMyPocket: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var productTypeWithSalePrice: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var widthOfImgView: NSLayoutConstraint!
    @IBOutlet weak var heightOfImgView: NSLayoutConstraint!
    @IBOutlet weak var sumOfCB: UITextField!
    
    var scannedImage: UIImage?
    var allData = [String : String]()
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if (Int(sumOfCB.text!)! % 1000) == 0 {
            if let mySum = UserDefaults.standard.object(forKey: "cashSumData") {
                if Int(sumOfCB.text!)! <= Int((mySum as! String).removingWhitespaces())! {
                    performSegue(withIdentifier: "nextSegue", sender: self)
                } else {
                    alertView(title: "Недостаточно средств для оплаты", message: "")
                }
            }
        } else {
            alertView(title: NSLocalizedString("Цена должна быть кратна 1000", comment: "Цена должна быть кратна 1000"), message: "")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextSegue" {
            let vc = segue.destination as! ReceiptCBViewController
            vc.allData = self.allData
            vc.cashbackSum = self.sumOfCB.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        self.productName.text = allData["productNameData"]!.uppercased()
        self.productType.text = "\(String(describing: allData["productTypeData"]!)), \(String(describing: allData["productColorData"]!.lowercased())), \(String(describing: allData["productSizeData"]!)), \(String(describing: allData["productArticulData"]!.uppercased()))"
        self.inMyPocket.text = "\(String(describing: UserDefaults.standard.object(forKey: "cashSumData")!)) \(NSLocalizedString("сум", comment: "сум"))"
        self.productPriceWithoutSalePrice.text = "\(allData["priceData"]!) сум"
        self.productTypeWithSalePrice.text = allData["percentPriceData"]!
        self.percentLabel.text = "-\(allData["percentData"]!)%"
    }
    
    /////Keyboard dissappear when touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /////Keyboard dissappear when return button tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func initial() {
        heightOfImgView.constant = self.view.frame.size.width / 2
        if scannedImage != nil {
            self.image.image = scannedImage
        }
        sumOfCB.layer.borderWidth = 1
        sumOfCB.layer.borderColor = UIColor.white.cgColor
    }
    
    func alertView(title: String, message: String) {
        let notification = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        notification.addAction(UIAlertAction(title: NSLocalizedString("Продолжить", comment: "Продолжить"), style: UIAlertAction.Style.destructive)
        { (action:UIAlertAction!) in
            
            }
        )
        self.present(notification, animated: true, completion: nil)
    }
}
