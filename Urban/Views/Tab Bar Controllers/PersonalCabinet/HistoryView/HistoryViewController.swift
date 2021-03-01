//
//  HistoryViewController.swift
//  Urban
//
//  Created by Khusan on 02.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class HistoryViewController: HistoryViewControllerFuncs, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dataTableViewOutlet: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var index = IndexPath()
    private var cellTapped = Bool()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HistoryViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha:1.0)
        return refreshControl
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)! {
            activityIndicator.startAnimating()
            dataTableViewOutlet.isHidden = true
            historyInfo() { (connected) -> (Void) in
                if connected == true {
                    self.activityIndicator.stopAnimating()
                    self.dataTableViewOutlet.reloadData()
                    self.dataTableViewOutlet.isHidden = false
                } else {
                    self.noInternetConnection()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        dataTableViewOutlet.isHidden = true
        historyInfo() { (connected) -> (Void) in
            if connected == true {
                self.activityIndicator.stopAnimating()
                self.dataTableViewOutlet.reloadData()
                self.dataTableViewOutlet.isHidden = false
            } else {
                self.noInternetConnection()
            }
        }
        searchBar.text!.removeAll()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearData()
        activityIndicator.startAnimating()
        dataTableViewOutlet.isHidden = true
        searchData(name: searchBar.text!) { (connected) -> (Void) in
            if connected == true {
                self.activityIndicator.stopAnimating()
                self.dataTableViewOutlet.reloadData()
                self.dataTableViewOutlet.isHidden = false
                self.view.endEditing(true)
            } else {
                self.noInternetConnection()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as! HistoryTableViewCell
        cell.dateOfBuy.text = self.date[indexPath.row]
        cell.nameOfProduct.text = self.productName[indexPath.row]
        cell.addressOfShop.text = self.filial[indexPath.row]
        cell.articulOfProduct.text = self.productArticul[indexPath.row]
        cell.typeOfProduct.text = self.productType[indexPath.row]
        cell.sizeOfProduct.text = self.productSize[indexPath.row]
        cell.colorOfProduct.text = self.productColor[indexPath.row]
        cell.chequeNumber.text = self.chequeNumber[indexPath.row]
        cell.cash.text = self.paymentCash[indexPath.row]
        if self.paymentCart[indexPath.row] == "0" {
            cell.cardStack.isHidden = true
        } else {
            cell.cardStack.isHidden = false
            cell.card.text = self.paymentCart[indexPath.row]
        }
        cell.cashback.text = self.paymentCashback[indexPath.row]
        cell.resultSum.text = self.amount[indexPath.row]
        cell.resultCashback.text = self.cashback[indexPath.row]
        cell.hideTextLabel.text = NSLocalizedString("Подробнее", comment: "Подробнее")
        cell.arrow.transform = CGAffineTransform(rotationAngle: 0)
        cell.secondStack.isHidden = true
        cell.leftConstraint.constant = 20
        cell.rightConstraint.constant = 20
        if cellTapped == true {
            if indexPath == index {
                if cellTapped == false {
                    cell.hideTextLabel.text = NSLocalizedString("Подробнее", comment: "Подробнее")
                    cell.arrow.transform = CGAffineTransform(rotationAngle: 0)
                    cell.secondStack.isHidden = true
                    cell.leftConstraint.constant = 20
                    cell.rightConstraint.constant = 20
                } else {
                    cell.hideTextLabel.text = NSLocalizedString("Свернуть", comment: "Свернуть")
                    cell.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    cell.secondStack.isHidden = false
                    cell.leftConstraint.constant = 0
                    cell.rightConstraint.constant = 0
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if index == indexPath {
            index = []
        } else {
            index = indexPath
        }
        cellTapped = true
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            dataTableViewOutlet.refreshControl = refreshControl
        } else {
            dataTableViewOutlet.addSubview(refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        searchBar.showsCancelButton = false
        activityIndicator.startAnimating()
        dataTableViewOutlet.isHidden = true
        historyInfo() { (connected) -> (Void) in
            if connected == true {
                self.activityIndicator.stopAnimating()
                self.dataTableViewOutlet.reloadData()
                self.dataTableViewOutlet.isHidden = false
            } else {
                if let paymentCashback = UserDefaults.standard.object(forKey: "paymentCashbackInHistory"), let productType = UserDefaults.standard.object(forKey: "productTypeInHistory"), let paymentCart = UserDefaults.standard.object(forKey: "paymentCartInHistory"), let paymentCartName = UserDefaults.standard.object(forKey: "paymentCartNameInHistory"), let filial = UserDefaults.standard.object(forKey: "filialInHistory"), let productColor = UserDefaults.standard.object(forKey: "productColorInHistory"), let productSize = UserDefaults.standard.object(forKey: "productSizeInHistory"), let date = UserDefaults.standard.object(forKey: "dateInHistory"), let cashback = UserDefaults.standard.object(forKey: "cashbackInHistory"), let paymentCash = UserDefaults.standard.object(forKey: "paymentCashInHistory"), let amount = UserDefaults.standard.object(forKey: "amountInHistory"), let productName = UserDefaults.standard.object(forKey: "productNameInHistory"), let productArticul = UserDefaults.standard.object(forKey: "productArticulInHistory"), let chequeNumber = UserDefaults.standard.object(forKey: "productChequeNumber") {
                    self.paymentCashback = paymentCashback as! [String]
                    self.productType = productType as! [String]
                    self.paymentCart = paymentCart as! [String]
                    self.paymentCartName = paymentCartName as! [String]
                    self.filial = filial as! [String]
                    self.productColor = productColor as! [String]
                    self.productSize = productSize as! [String]
                    self.date = date as! [String]
                    self.cashback = cashback as! [String]
                    self.paymentCash = paymentCash as! [String]
                    self.amount = amount as! [String]
                    self.productName = productName as! [String]
                    self.productArticul = productArticul as! [String]
                    self.chequeNumber = chequeNumber as! [String]
                }
                self.noInternetConnection()
                self.activityIndicator.stopAnimating()
                self.dataTableViewOutlet.reloadData()
                self.dataTableViewOutlet.isHidden = false
            }
        }
    }
    
    @objc func keyboardWillAppear() {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    @objc func keyboardWillDisappear() {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    @objc private func handleRefresh(_ sender: Any) {
        // Fetch Weather Data
        searchBar.showsCancelButton = false
        historyInfo() { (connected) -> (Void) in
            if connected == true {
                self.dataTableViewOutlet.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                if let paymentCashback = UserDefaults.standard.object(forKey: "paymentCashbackInHistory"), let productType = UserDefaults.standard.object(forKey: "productTypeInHistory"), let paymentCart = UserDefaults.standard.object(forKey: "paymentCartInHistory"), let paymentCartName = UserDefaults.standard.object(forKey: "paymentCartNameInHistory"), let filial = UserDefaults.standard.object(forKey: "filialInHistory"), let productColor = UserDefaults.standard.object(forKey: "productColorInHistory"), let productSize = UserDefaults.standard.object(forKey: "productSizeInHistory"), let date = UserDefaults.standard.object(forKey: "dateInHistory"), let cashback = UserDefaults.standard.object(forKey: "cashbackInHistory"), let paymentCash = UserDefaults.standard.object(forKey: "paymentCashInHistory"), let amount = UserDefaults.standard.object(forKey: "amountInHistory"), let productName = UserDefaults.standard.object(forKey: "productNameInHistory"), let productArticul = UserDefaults.standard.object(forKey: "productArticulInHistory"), let chequeNumber = UserDefaults.standard.object(forKey: "productChequeNumber") {
                    self.paymentCashback = paymentCashback as! [String]
                    self.productType = productType as! [String]
                    self.paymentCart = paymentCart as! [String]
                    self.paymentCartName = paymentCartName as! [String]
                    self.filial = filial as! [String]
                    self.productColor = productColor as! [String]
                    self.productSize = productSize as! [String]
                    self.date = date as! [String]
                    self.cashback = cashback as! [String]
                    self.paymentCash = paymentCash as! [String]
                    self.amount = amount as! [String]
                    self.productName = productName as! [String]
                    self.productArticul = productArticul as! [String]
                    self.chequeNumber = chequeNumber as! [String]
                }
                self.noInternetConnection()
                self.refreshControl.endRefreshing()
                self.dataTableViewOutlet.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    /////Keyboard dissappear when touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func clearData() {
        self.paymentCashback.removeAll()
        self.productType.removeAll()
        self.paymentCart.removeAll()
        self.paymentCartName.removeAll()
        self.filial.removeAll()
        self.productColor.removeAll()
        self.productSize.removeAll()
        self.date.removeAll()
        self.cashback.removeAll()
        self.paymentCash.removeAll()
        self.amount.removeAll()
        self.productName.removeAll()
        self.productArticul.removeAll()
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
