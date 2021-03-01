//
//  ConfirmCodeViewController.swift
//  Urban
//
//  Created by Khusan on 29.12.2017.
//  Copyright © 2017 GlobalSolutions. All rights reserved.
//

import UIKit

class ConfirmCodeViewController: ConfirmCodeViewControllerFuncs, UITextFieldDelegate {

    @IBOutlet weak var confirmCodeTextLabel: UILabel!
    @IBOutlet weak var confirmCodeTextField: UITextField!
    @IBOutlet weak var resendCodeButtonOutlet: UIButton!
    @IBOutlet weak var nextButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var phoneNumber = String()
    private var code = String()
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        confirmCode(phone: phoneNumber, code: Int(code)!) { (connected) -> (Void) in
            if connected == true {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                if self.isActivated == 1 {
                    self.performSegue(withIdentifier: "reg", sender: self)
                } else {
                    self.performSegue(withIdentifier: "notReg", sender: self)
                }
            } else {
                if self.error.isEmpty {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.noInternetConnection()
                } else {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.alertView(title: NSLocalizedString("Неверный код", comment: "Неверный код"), message: "")
                }
            }
        }
    }
    
    @IBAction func resendCodeAction(_ sender: Any) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        takeCode(phoneNumber: phoneNumber) { (connected) -> (Void) in
            if connected == false {
                self.noInternetConnection()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }

        }
    }
    
    @IBAction func codeTextField(_ sender: Any) {
        if confirmCodeTextField.text?.isEmpty == true {
            nextButtonOutlet.isEnabled = false
        } else {
            nextButtonOutlet.isEnabled = true
            code = confirmCodeTextField.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
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
        nextButtonOutlet.isEnabled = false
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        confirmCodeTextField.leftView = leftView
        confirmCodeTextField.leftViewMode = .always
        confirmCodeTextField.layer.borderWidth = 0.5
        confirmCodeTextField.layer.borderColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1).cgColor
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
