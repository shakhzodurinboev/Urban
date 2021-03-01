//
//  PersonalCabinetViewController.swift
//  Urban
//
//  Created by Khusan on 02.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import TGPControls
import Reachability

class PersonalCabinetViewController: PersonalCabinetViewControllerFuncs {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var genderAndAgeLabel: UILabel!
    
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var yourSaleLabel: UILabel!
    @IBOutlet weak var salePersentView: UIView!
    @IBOutlet weak var salePersentLabel: UILabel!
    @IBOutlet weak var saleInfoImage: UIImageView!
    @IBOutlet weak var saleMinSum: UILabel!
    @IBOutlet weak var saleMaxSum: UILabel!
    @IBOutlet weak var saleSlider: TGPDiscreteSlider!
    @IBOutlet weak var saleMinPersent: UILabel!
    @IBOutlet weak var saleMaxPersent: UILabel!
    @IBOutlet weak var saleCurrentSum: UILabel!
    
    @IBOutlet weak var cashView: UIView!
    @IBOutlet var cashCurrentSums: [UILabel]?
    @IBOutlet weak var cashMinSum: UILabel!
    @IBOutlet weak var cashMaxSum: UILabel!
    @IBOutlet weak var cashSlider: TGPDiscreteSlider!
    @IBOutlet weak var cashInfoButton: UIButton!
    
    @IBAction func infoButtonAction(_ sender: UIButton) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        if sender.tag == 0 {
            getInfo(method: "sale", connected: { (connected) -> (Void) in
                if connected == true {
                    self.activityIndicator.stopAnimating()
                    self.alertView(title: self.saleInfo, message: "")
                    UIApplication.shared.endIgnoringInteractionEvents()
                } else {
                    if let saleInfo = UserDefaults.standard.object(forKey: "saleInfoInPersonalCab") {
                        self.alertView(title: saleInfo as! String, message: "")
                    } else {
                        self.noInternetConnection()
                    }
                }
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        } else {
            getInfo(method: "cashback", connected: { (connected) -> (Void) in
                if connected == true {
                    self.activityIndicator.stopAnimating()
                    self.alertView(title: self.cashbackInfo, message: "")
                    UIApplication.shared.endIgnoringInteractionEvents()
                } else {
                    if let cashInfo = UserDefaults.standard.object(forKey: "cashInfoInPersonalCab") {
                        self.alertView(title: cashInfo as! String, message: "")
                    } else {
                        self.noInternetConnection()
                    }
                }
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
    }
    
    @IBAction func socialButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            UIApplication.shared.openURL(URL(string: "https://www.facebook.com/urbanstoretashkent/")!)
        } else if sender.tag == 1 {
            UIApplication.shared.openURL(URL(string: "https://www.instagram.com/urbantashkent/")!)
        } else if sender.tag == 2 {
            UIApplication.shared.openURL(URL(string: "https://telegram.me/urbanstoretashkent")!)
        }
    }
    
    @IBAction func exitButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "exitSegue", sender: self)
        UserDefaults.standard.set(false, forKey: "UserIsLogged")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.isHidden = true
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.getUserInfo() { (connected) -> (Void) in
            if connected == true {
                self.nameSurnameLabel.text = "\(self.name) \(self.surname)"
                self.phoneNumberLabel.text = "+\(self.phone)"
                self.profileImage.kf.indicatorType = .activity
                if self.photo != "" {
                    self.profileImage.kf.setImage(with: URL(string: self.photo)!)
                } else {
                    self.profileImage.image = #imageLiteral(resourceName: "shape")
                }
                if self.gender == "M" {
                    if self.birthday.isEmpty {
                        self.genderAndAgeLabel.text = NSLocalizedString("Муж.", comment: "Муж.")
                    } else {
                        self.genderAndAgeLabel.text = "\(NSLocalizedString("Муж.", comment: "Муж.")), \(self.calculateToAge(dateOfBirth: self.birthday)) \(NSLocalizedString("лет", comment: "лет"))"
                    }
                } else {
                    if self.birthday.isEmpty {
                        self.genderAndAgeLabel.text = NSLocalizedString("Жен.", comment: "Жен.")
                    } else {
                        self.genderAndAgeLabel.text = "\(NSLocalizedString("Жен.", comment: "Жен.")), \(self.calculateToAge(dateOfBirth: self.birthday)) \(NSLocalizedString("лет", comment: "лет"))"
                    }
                }
                ///////Sale
                let sliderSaleValue = Int((Int(self.saleSumData.removingWhitespaces())! - Int(self.saleMinSumData.removingWhitespaces())!) * 10) / (Int(self.saleMaxSumData.removingWhitespaces())! - Int(self.saleMinSumData.removingWhitespaces())!)
                self.saleSlider.value = CGFloat(sliderSaleValue)
                self.salePersentLabel.text = "\(self.salePerData)%"
                self.saleMinSum.text = "\(self.saleMinSumData) \(NSLocalizedString("сум", comment: "сум"))"
                self.saleMaxSum.text = "\(self.saleMaxSumData) \(NSLocalizedString("сум", comment: "сум"))"
                self.saleMinPersent.text = "\(self.saleMinPerData)%"
                self.saleMaxPersent.text = "\(self.saleMaxPerData)%"
                self.saleCurrentSum.text = "\(self.saleSumData) \(NSLocalizedString("сум", comment: "сум"))"
                ///////Cashback
                let sliderCashValue = Int(Int(self.cashSumData.removingWhitespaces())! * 10) / (Int(self.cashMaxSumData.removingWhitespaces()))!
                self.cashSlider.value = CGFloat(sliderCashValue)
                self.cashCurrentSums?.forEach({ (label) in
                    label.text = "\(self.cashSumData) \(NSLocalizedString("сум", comment: "сум"))"
                })
                self.cashMaxSum.text = "MAX \(self.cashMaxSumData) \(NSLocalizedString("сум", comment: "сум"))"
                if self.cashbackStatus == 2 {
                    self.cashInfoButton.tintColor = UIColor.yellow
                } else if self.cashbackStatus == 3 {
                    self.cashInfoButton.tintColor = UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1)
                }
                self.saveToCache()
                self.scrollView.isHidden = false
            } else {
                self.noInternetConnection()
                if let name = UserDefaults.standard.object(forKey: "UsersName"), let surname = UserDefaults.standard.object(forKey: "UsersSurname"), let phone = UserDefaults.standard.object(forKey: "UsersPhone"), let photo = UserDefaults.standard.object(forKey: "UsersPhoto"), let gender = UserDefaults.standard.object(forKey: "UsersGender"), let salePersent = UserDefaults.standard.object(forKey: "salePerData"), let saleMinSum = UserDefaults.standard.object(forKey: "saleMinSumData"), let saleMaxSum = UserDefaults.standard.object(forKey: "saleMaxSumData"), let saleMinPersent = UserDefaults.standard.object(forKey: "saleMinPerData"), let saleMaxPersent = UserDefaults.standard.object(forKey: "saleMaxPerData"), let saleCurrentSum = UserDefaults.standard.object(forKey: "saleSumData"), let cashCurrentSum = UserDefaults.standard.object(forKey: "cashSumData"), let cashMaxSum = UserDefaults.standard.object(forKey: "cashMaxSumData"), let birthday = UserDefaults.standard.object(forKey: "UsersBirthday"), let cashStatus = UserDefaults.standard.object(forKey: "cashStatusInPersonalCab") {
                    self.nameSurnameLabel.text = "\(name as! String) \(surname as! String)"
                    self.phoneNumberLabel.text = "+\(phone as! String)"
                    self.profileImage.kf.indicatorType = .activity
                    if photo as! String != "" {
                        self.profileImage.kf.setImage(with: URL(string: photo as! String)!)
                    } else {
                        self.profileImage.image = #imageLiteral(resourceName: "shape")
                    }
                    if gender as! String == "M" {
                        if (birthday as! String).isEmpty {
                            self.genderAndAgeLabel.text = NSLocalizedString("Муж.", comment: "Муж.")
                        } else {
                            self.genderAndAgeLabel.text = "\(NSLocalizedString("Муж.", comment: "Муж.")), \(self.calculateToAge(dateOfBirth: birthday as! String)) \(NSLocalizedString("лет", comment: "лет"))"
                        }
                    } else {
                        if (birthday as! String).isEmpty {
                            self.genderAndAgeLabel.text = NSLocalizedString("Жен.", comment: "Жен.")
                        } else {
                            self.genderAndAgeLabel.text = "\(NSLocalizedString("Жен.", comment: "Жен.")), \(self.calculateToAge(dateOfBirth: birthday as! String)) \(NSLocalizedString("лет", comment: "лет"))"
                        }
                    }
                    ///////Sale
                    let sliderSaleValue = Int(Int(String(describing: saleCurrentSum).removingWhitespaces())! * 10) / (Int(String(describing: saleMaxSum).removingWhitespaces()))!
                    self.saleSlider.value = CGFloat(sliderSaleValue)
                    self.salePersentLabel.text = "\(String(describing: salePersent))%"
                    self.saleMinSum.text = "\(String(describing: saleMinSum)) \(NSLocalizedString("сум", comment: "сум"))"
                    self.saleMaxSum.text = "\(String(describing: saleMaxSum)) \(NSLocalizedString("сум", comment: "сум"))"
                    self.saleMinPersent.text = "\(String(describing: saleMinPersent))%"
                    self.saleMaxPersent.text = "\(String(describing: saleMaxPersent))%"
                    self.saleCurrentSum.text = "\(String(describing: saleCurrentSum)) \(NSLocalizedString("сум", comment: "сум"))"
                    ///////Cashback
                    let sliderCashValue = Int(Int(String(describing: cashCurrentSum).removingWhitespaces())! * 10) / (Int(String(describing: cashMaxSum).removingWhitespaces()))!
                    self.cashSlider.value = CGFloat(sliderCashValue)
                    self.cashCurrentSums?.forEach({ (label) in
                    label.text = "\(String(describing: cashCurrentSum)) \(NSLocalizedString("сум", comment: "сум"))"
                    })
                    self.cashMaxSum.text = "MAX \(String(describing: cashMaxSum)) \(NSLocalizedString("сум", comment: "сум"))"
                    if cashStatus as! Int == 2 {
                        self.cashInfoButton.tintColor = UIColor.yellow
                    } else if cashStatus as! Int == 3 {
                        self.cashInfoButton.tintColor = UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1)
                    }
                }
                self.scrollView.isHidden = false
            }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }
    
    func calculateToAge(dateOfBirth: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let date = dateFormatter.date(from: dateOfBirth) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        let gregorian = Calendar(identifier: .gregorian)
        let ageComponents = gregorian.dateComponents([.year], from: date, to: Date())
        let age = ageComponents.year!
        return age
    }
    
    func saveToCache() {
        //////UsersData
        UserDefaults.standard.set(self.name, forKey: "UsersName")
        UserDefaults.standard.set(self.surname, forKey: "UsersSurname")
        UserDefaults.standard.set(self.photo, forKey: "UsersPhoto")
        UserDefaults.standard.set(self.phone, forKey: "UsersPhone")
        UserDefaults.standard.set(self.gender, forKey: "UsersGender")
        UserDefaults.standard.set(self.birthday, forKey: "UsersBirthday")
        //////SaleData
        UserDefaults.standard.set(self.salePerData, forKey: "salePerData")
        UserDefaults.standard.set(self.saleMinSumData, forKey: "saleMinSumData")
        UserDefaults.standard.set(self.saleMaxSumData, forKey: "saleMaxSumData")
        UserDefaults.standard.set(self.saleMinPerData, forKey: "saleMinPerData")
        UserDefaults.standard.set(self.saleMaxPerData, forKey: "saleMaxPerData")
        UserDefaults.standard.set(self.saleSumData, forKey: "saleSumData")
        //////CashbackData
        UserDefaults.standard.set(self.cashSumData, forKey: "cashSumData")
        UserDefaults.standard.set(self.cashMaxSumData, forKey: "cashMaxSumData")
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
