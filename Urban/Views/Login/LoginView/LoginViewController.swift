//
//  ViewController.swift
//  Urban
//
//  Created by Khusan on 29.12.2017.
//  Copyright © 2017 GlobalSolutions. All rights reserved.
//

import UIKit
import InputMask
import Reachability

class LoginViewController: LoginViewControllerFuncs, MaskedTextFieldDelegateListener, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var takeCodeButtonOutlet: UIButton!
    @IBOutlet weak var mainImageOutlet: UIImageView!
    @IBOutlet weak var logoImageOutlet: UIImageView!
    @IBOutlet weak var enterPhoneNumberTextLabel: UILabel!
    @IBOutlet weak var phoneCodeLabel: UITextField!
    @IBOutlet weak var phoneTextOutlet: UITextField!
    @IBOutlet var listener: MaskedTextFieldDelegate!
    @IBOutlet weak var agreementCheck: VKCheckbox!
    
    private let reachability = try! Reachability()
    private var phoneNumber = String()
    
    @IBAction func takeCodeButtonAction(_ sender: Any) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
        print(phoneNumber)
        takeCode(phoneNumber: phoneNumber) { (connected) -> (Void) in
            if connected == false {
                self.noInternetConnection()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "takeCodeSegue", sender: self)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    @IBAction func offerButtonAction(_ sender: Any) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
        getInfo { (connected) -> (Void) in
            if connected == true {
                self.alertView(title: self.offerInfo, message: "")
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
            } else {
                if let offer = UserDefaults.standard.object(forKey: "offerInfo") {
                    self.alertView(title: offer as! String, message: "")
                } else {
                    self.noInternetConnection()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "takeCodeSegue" {
            let sender = segue.destination as! ConfirmCodeViewController
            sender.phoneNumber = self.phoneNumber
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        initial()
        listener.affineFormats = [
            "([00]) [000]-[00]-[00]"
        ]
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
    
    open func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
        ) {
        if value.count == 9 {
            phoneNumber = "998\(value)"
            if agreementCheck.isOn() == true {
                takeCodeButtonOutlet.isHidden = false
            } else {
                takeCodeButtonOutlet.isHidden = true
            }
        } else {
            takeCodeButtonOutlet.isHidden = true
        }
    }
    
    func initial() {
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "DaysOne-Regular", size: 15)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        takeCodeButtonOutlet.isHidden = true
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        phoneTextOutlet.leftView = leftView
        phoneTextOutlet.leftViewMode = .always
        phoneCodeLabel.layer.borderWidth = 0.5
        phoneCodeLabel.layer.borderColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1).cgColor
        phoneTextOutlet.layer.borderWidth = 0.5
        phoneTextOutlet.layer.borderColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1).cgColor
        
        agreementCheck.line = .thin
        agreementCheck.bgColorSelected = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)
        agreementCheck.bgColor = .white
        agreementCheck.color = .white
        agreementCheck.borderColor = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)
        agreementCheck.borderWidth = 1
        agreementCheck.cornerRadius = 2
        agreementCheck.checkboxValueChangedBlock = {
            isOn in
            if isOn == true && self.phoneTextOutlet.text?.count == 14 {
                self.takeCodeButtonOutlet.isHidden = false
            } else {
                self.takeCodeButtonOutlet.isHidden = true
            }
            print("Basic checkbox is \(isOn ? "ON" : "OFF")")
        }
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
