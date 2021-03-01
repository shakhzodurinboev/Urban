//
//  ReceiptCBViewController.swift
//  Urban
//
//  Created by Khusan on 19.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class ReceiptCBViewController: ReceiptCBViewControllerFuncs {
    
    @IBOutlet weak var chequeView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var payFromCashback: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var productTypeWithSalePrice: UILabel!
    @IBOutlet weak var myCashback: UILabel!
    
    var cashbackSum = String()
    var allData = [String : String]()
    
    @IBAction func downloadChequeButtonAction(_ sender: Any) {
        let image = UIImage.init(view: chequeView)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        payFromCashback.text = "- \(cashbackSum)"
        productName.text = allData["productNameData"]!.uppercased()
        productType.text = "\(String(describing: allData["productTypeData"]!)), \(String(describing: allData["productColorData"]!.lowercased())), \(String(describing: allData["productSizeData"]!)), \(String(describing: allData["productArticulData"]!.uppercased()))"
        productTypeWithSalePrice.text = allData["percentPriceData"]!
        myCashback.text = "+\(allData["cashbackData"]!)"
        percentLabel.text = "\(allData["percentData"]!)%"
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: NSLocalizedString("Ошибка при сохранении чека", comment: "Ошибка при сохранении чека"), message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: NSLocalizedString("Ваш чек сохранен", comment: "Ваш чек сохранен"), message: "", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func initial() {
        infoView.layer.borderColor = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1).cgColor
        infoView.layer.borderWidth = 2
        infoView.layer.cornerRadius = 3
    }
}
