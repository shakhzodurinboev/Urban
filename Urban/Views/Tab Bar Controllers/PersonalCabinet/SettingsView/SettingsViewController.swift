//
//  RegistrationViewController.swift
//  Urban
//
//  Created by Khusan on 30.12.2017.
//  Copyright © 2017 GlobalSolutions. All rights reserved.
//

import UIKit
import GoogleSignIn
import Kingfisher
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class SettingsViewController: SettingsViewControllerFuncs, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate, GIDSignInDelegate {
    var checkProfileImage = false
    
    @IBOutlet weak var submitButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enterNameTextField: UITextField!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var enterSurnameTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var manSelectorImage: UIImageView!
    @IBOutlet weak var manLabel: UILabel!
    @IBOutlet weak var womanSelectorImage: UIImageView!
    @IBOutlet weak var womanLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var changeLanguageLabel: UILabel!
    @IBOutlet weak var russView: UIView!
    @IBOutlet weak var russLabel: UILabel!
    @IBOutlet weak var russCheckImg: UIImageView!
    @IBOutlet weak var engView: UIView!
    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var engCheckImg: UIImageView!
    @IBOutlet weak var uzbView: UIView!
    @IBOutlet weak var uzbLabel: UILabel!
    @IBOutlet weak var uzbCheckImg: UIImageView!
    
    @IBOutlet var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var backButtonInDateView: UIButton!
    @IBOutlet weak var selectButtonInDateView: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var gender = String()
    private var birthday = String()
    private var lang = UserDefaults.standard.object(forKey: "AppLang") as! String
    private var langToSys = String()
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        if !self.checkProfileImage {
            changeFunc(token: UserDefaults.standard.object(forKey: "UsersToken") as! String, name: enterNameTextField.text!, lastname: enterSurnameTextField.text!, photo: "", gender: gender, birthday: convertDateToServ(birthdayTextField.text!), notice: 1, lang: UserDefaults.standard.object(forKey: "AppLang") as! String) { (connected) -> (Void) in
                if connected == false {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.noInternetConnection()
                } else {
                    if self.success == true {
                        UserDefaults.standard.set(self.lang, forKey: "AppLang")
                        L102Language.setAppleLAnguageTo(lang: self.langToSys)
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        rootviewcontroller.rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
                        self.submitButtonOutlet.isEnabled = false
                        self.activityIndicator.stopAnimating()
                    } else {
                        print("smth went wrong")
                    }
                }
            }
        } else {
            changeFunc(token: UserDefaults.standard.object(forKey: "UsersToken") as! String, name: enterNameTextField.text!, lastname: enterSurnameTextField.text!, photo: "", gender: gender, birthday: convertDateToServ(birthdayTextField.text!), notice: 1, lang: UserDefaults.standard.object(forKey: "AppLang") as! String) { (connected) -> (Void) in
                          if connected == false {
                              self.activityIndicator.stopAnimating()
                              UIApplication.shared.endIgnoringInteractionEvents()
                              self.noInternetConnection()
                          } else {
                              if self.success == true {
                                  self.uploadPhoto(lang: UserDefaults.standard.object(forKey: "AppLang") as! String, image: self.profileImage.image!) { (check) in
                                      if check {
                                          UserDefaults.standard.set(self.lang, forKey: "AppLang")
                                          L102Language.setAppleLAnguageTo(lang: self.langToSys)
                                          UIApplication.shared.endIgnoringInteractionEvents()
                                          
                                          self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                                          let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
                                          let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                          rootviewcontroller.rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
                                          
                                          self.submitButtonOutlet.isEnabled = false
                                          self.activityIndicator.stopAnimating()
                                      } else {
                                          self.activityIndicator.stopAnimating()
                                          UIApplication.shared.endIgnoringInteractionEvents()
                                          self.noInternetConnection()
                                      }
                                  }
                              } else {
                                  print("smth went wrong")
                              }
                          }
                      }
        }
      
    }
    
    
    @IBAction func profileImageButtonAction(_ sender: Any) {
        self.checkProfileImage = true
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        editImage.isHidden = false
        actionSheet.view.tintColor = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)
        let cameraAction = UIAlertAction(title: NSLocalizedString("Камера", comment: "Камера"), style: .default) { action in
            self.showCamera()
            self.editImage.isHidden = true
        }
        actionSheet.addAction(cameraAction)
        let albumAction = UIAlertAction(title: NSLocalizedString("Библиотека", comment: "Библиотека"), style: .default) { action in
            self.openPhotoAlbum()
            self.editImage.isHidden = true
        }
        actionSheet.addAction(albumAction)
        if profileImage.image != UIImage(named: "shape.png") {
            let deleteAction = UIAlertAction(title: NSLocalizedString("Удалить", comment: "Удалить"), style: .default) { action in
                self.checkProfileImage = false
                self.profileImage.image = #imageLiteral(resourceName: "shape")
                self.editImage.isHidden = true
                if self.enterNameTextField.text?.isEmpty == false {
                    self.submitButtonOutlet.isEnabled = true
                }
            }
            actionSheet.addAction(deleteAction)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: "Отмена"), style: .cancel) { action in
            self.checkProfileImage = false
            self.editImage.isHidden = true
        }
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: {() -> Void in            actionSheet.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        })
    }
    
    @IBAction func textFieldsAction(_ sender: UITextField) {
        if sender.tag == 0 {
            if (enterNameTextField.text?.isEmpty)! || gender.isEmpty {
                submitButtonOutlet.isEnabled = false
            } else {
                submitButtonOutlet.isEnabled = true
            }
        } else if sender.tag == 1 {
            
        }
    }
    
    @IBAction func genderButtonAction(_ sender: UIButton) {
        if sender.tag == 0 {
            gender = "M"
            manSelectorImage.isHighlighted = true
            womanSelectorImage.isHighlighted = false
            manLabel.textColor = UIColor.black
            womanLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
        } else if sender.tag == 1 {
            gender = "F"
            manSelectorImage.isHighlighted = false
            womanSelectorImage.isHighlighted = true
            manLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            womanLabel.textColor = UIColor.black
        }
        if (enterNameTextField.text?.isEmpty)! || gender.isEmpty {
            submitButtonOutlet.isEnabled = false
        } else {
            submitButtonOutlet.isEnabled = true
        }
    }
    
    @IBAction func birthdayButtonTapped(_ sender: Any) {
        view.endEditing(true)
        datePickerView.frame = CGRect(origin: self.scrollView.frame.origin, size: self.scrollView.frame.size)
        datePickerView.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 0.5)
        self.view.addSubview(self.datePickerView)
    }
    
    @IBAction func backButtonInDateViewTapped(_ sender: Any) {
        datePickerView.removeFromSuperview()
    }
    
    @IBAction func selectButtonInDateViewTapped(_ sender: Any) {
        birthdayTextField.text = formattedDateToTextField(date: datePicker.date)
        datePickerView.removeFromSuperview()
        if self.enterNameTextField.text?.isEmpty == false {
            self.submitButtonOutlet.isEnabled = true
        }
    }
    
    @IBAction func socialButtonsAction(_ sender: UIButton) {
        if sender.tag == 0 {
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    // if user cancel the login
                    if (result?.isCancelled)!{
                        return
                    }
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        } else if sender.tag == 1 {
            GIDSignIn.sharedInstance().presentingViewController = self
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    @IBAction func langButtonAction(_ sender: UIButton) {
        if sender.tag == 0 {
            russCheckImg.isHidden = false
            engCheckImg.isHidden = true
            uzbCheckImg.isHidden = true
            russLabel.textColor = UIColor.black
            engLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            uzbLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            lang = "rus"
            langToSys = "en"
        } else if sender.tag == 1 {
            russCheckImg.isHidden = true
            engCheckImg.isHidden = false
            uzbCheckImg.isHidden = true
            russLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            engLabel.textColor = UIColor.black
            uzbLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            lang = "eng"
            langToSys = "en-US"
        } else if sender.tag == 2 {
            russCheckImg.isHidden = true
            engCheckImg.isHidden = true
            uzbCheckImg.isHidden = false
            russLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            engLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            uzbLabel.textColor = UIColor.black
            lang = "uzb"
            langToSys = "uz"
        }
        if self.enterNameTextField.text?.isEmpty == false {
            self.submitButtonOutlet.isEnabled = true
        }
    }
    
    func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), gender, birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if error != nil {
                    // Some error checking here
                } else if let userData = result as? [String:AnyObject] {
                    // Access user data
                    self.enterNameTextField.text! = userData["first_name"] as! String
                    self.enterSurnameTextField.text! = userData["last_name"] as! String
                    let userPhotoURL = userData["picture"]  as! [String:AnyObject]
                    let data = userPhotoURL["data"]  as! [String:AnyObject]
                    let check = data["is_silhouette"] as! Int
                    if check == 0 {
                        let url = data["url"] as! String
                        self.profileImage.kf.setImage(with: URL(string: url))
                    } else {
                        print("noImg")
                    }
                    let gen = userData["gender"] as! String
                    if gen == "male" {
                        self.gender = "M"
                        self.manSelectorImage.isHighlighted = true
                        self.womanSelectorImage.isHighlighted = false
                        self.manLabel.textColor = UIColor.black
                        self.womanLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
                    } else {
                        self.gender = "F"
                        self.manSelectorImage.isHighlighted = false
                        self.womanSelectorImage.isHighlighted = true
                        self.manLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
                        self.womanLabel.textColor = UIColor.black
                    }
                    self.birthdayTextField.text = self.convertDateToFB(String(describing: userData["birthday"] as! String))
                    if self.enterNameTextField.text?.isEmpty == false {
                        self.submitButtonOutlet.isEnabled = true
                    }
                }
            })
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        guard error == nil else {
            
            print("Error while trying to redirect : \(String(describing: error))")
            return
        }
        
        print("Successful Redirection")
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error == nil) {
            Alamofire.request("https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(user.authentication.accessToken!)", method: .get, encoding: JSONEncoding(options: []))
                .responseJSON {
                    response in
                    if response.error != nil {
                        if response.data == nil {
                            
                        } else {
                            
                        }
                    } else {
                        if let value = response.data {
                            let json = JSON(value)
                            print(json)
                            self.enterNameTextField.text = json["given_name"].stringValue
                            self.enterSurnameTextField.text = json["family_name"].stringValue
                            if user.profile.hasImage {
                                let image = user.profile.imageURL(withDimension: 400)!
                                self.profileImage.kf.setImage(with: image)
                            }
                            let gen = json["gender"].stringValue
                            if gen == "male" {
                                self.gender = "M"
                                self.manSelectorImage.isHighlighted = true
                                self.womanSelectorImage.isHighlighted = false
                                self.manLabel.textColor = UIColor.black
                                self.womanLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
                            } else {
                                self.gender = "F"
                                self.manSelectorImage.isHighlighted = false
                                self.womanSelectorImage.isHighlighted = true
                                self.manLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
                                self.womanLabel.textColor = UIColor.black
                            }
                        }
                        if self.enterNameTextField.text?.isEmpty == false {
                            self.submitButtonOutlet.isEnabled = true
                        }
                    }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        initial()
        langInitial()
    }
    
    func showCamera() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        present(controller, animated: true, completion: nil)
    }
    
    func openPhotoAlbum() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        profileImage.image = image
        if enterNameTextField.text?.isEmpty == false {
            self.submitButtonOutlet.isEnabled = true
        }
    }
    
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        dismiss(animated: true) { [unowned self] in
            self.openEditor(selectedImg: image)
        }
    }
    
    func openEditor(selectedImg: UIImage) {
        let controller = CropViewController()
        controller.cropAspectRatio = 1
        controller.keepAspectRatio = true
        controller.delegate = self
        controller.image = selectedImg
        controller.toolbarHidden = true
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    func formattedDateToTextField(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd  /  MM  /  yyyy"
        let strDate:String = dateFormatter.string(from: date)
        return strDate
    }
    
    func convertDateToFB(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd  /  MM  /  yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    func convertDateToServ(_ date: String) -> String {
        if date.isEmpty {
            return ""
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd  /  MM  /  yyyy"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return  dateFormatter.string(from: date!)
        }
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
    
    func redStar(fullString: String, label: UILabel) {
        let range = (fullString as NSString).range(of: "*")
        let attributedText = NSMutableAttributedString.init(string: fullString)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        label.attributedText = attributedText
    }
    
    func initial() {
        editImage.isHidden = true
        submitButtonOutlet.isEnabled = false
        redStar(fullString: nameLabel.text!, label: nameLabel)
        redStar(fullString: genderLabel.text!, label: genderLabel)
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        enterNameTextField.leftView = leftView
        enterNameTextField.leftViewMode = .always
        enterNameTextField.layer.borderWidth = 0.5
        enterNameTextField.layer.borderColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1).cgColor
        let leftView2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        enterSurnameTextField.leftView = leftView2
        enterSurnameTextField.leftViewMode = .always
        enterSurnameTextField.layer.borderWidth = 0.5
        enterSurnameTextField.layer.borderColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1).cgColor
        let leftView3 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        birthdayTextField.leftView = leftView3
        birthdayTextField.leftViewMode = .always
        birthdayTextField.layer.borderWidth = 0.5
        birthdayTextField.layer.borderColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1).cgColor
        facebookButton.layer.borderColor = UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1).cgColor
        facebookButton.layer.borderWidth = 1
        facebookButton.layer.cornerRadius = 2
        googleButton.layer.borderColor = UIColor(red: 214.0/255.0, green: 45.0/255.0, blue: 32.0/255.0, alpha: 1).cgColor
        googleButton.layer.borderWidth = 1
        googleButton.layer.cornerRadius = 2
        backButtonInDateView.layer.borderColor = UIColor(red: 214.0/255.0, green: 45.0/255.0, blue: 32.0/255.0, alpha: 1).cgColor
        backButtonInDateView.layer.borderWidth = 1
        backButtonInDateView.layer.cornerRadius = 2
        selectButtonInDateView.layer.cornerRadius = 2
        enterNameTextField.text = UserDefaults.standard.object(forKey: "UsersName") as? String
        enterSurnameTextField.text = UserDefaults.standard.object(forKey: "UsersSurname") as? String
        let url = URL(string: (UserDefaults.standard.object(forKey: "UsersPhoto") as? String)!)
        self.profileImage.kf.indicatorType = .activity
        if UserDefaults.standard.object(forKey: "UsersPhoto") as? String != "" {
            self.profileImage.kf.setImage(with: url)
        } else {
            self.profileImage.image = #imageLiteral(resourceName: "shape")
        }
        if UserDefaults.standard.object(forKey: "UsersGender") as? String == "M" {
            gender = "M"
            manSelectorImage.isHighlighted = true
            womanSelectorImage.isHighlighted = false
            manLabel.textColor = UIColor.black
            womanLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
        } else if UserDefaults.standard.object(forKey: "UsersGender") as? String == "F" {
            gender = "F"
            manSelectorImage.isHighlighted = false
            womanSelectorImage.isHighlighted = true
            manLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            womanLabel.textColor = UIColor.black
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let date = dateFormatter.date(from: UserDefaults.standard.object(forKey: "UsersBirthday") as! String) {
            dateFormatter.dateFormat = "dd  /  MM  /  yyyy"
            birthdayTextField.text = dateFormatter.string(from: date)
        }
    }
    
    func langInitial() {
        russView.layer.borderColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1).cgColor
        uzbView.layer.borderColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1).cgColor
        russView.layer.borderWidth = 0.5
        uzbView.layer.borderWidth = 0.5
        if UserDefaults.standard.object(forKey: "AppLang") as! String == "rus" {
            langToSys = "en"
            russCheckImg.isHidden = false
            engCheckImg.isHidden = true
            uzbCheckImg.isHidden = true
            russLabel.textColor = UIColor.black
            engLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            uzbLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
        } else if UserDefaults.standard.object(forKey: "AppLang") as! String == "eng" {
            langToSys = "en-US"
            russCheckImg.isHidden = true
            engCheckImg.isHidden = false
            uzbCheckImg.isHidden = true
            russLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            engLabel.textColor = UIColor.black
            uzbLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
        } else {
            langToSys = "uz"
            russCheckImg.isHidden = true
            engCheckImg.isHidden = true
            uzbCheckImg.isHidden = false
            russLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            engLabel.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
            uzbLabel.textColor = UIColor.black
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

let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// L102Language
class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        let endIndex = current.startIndex
        let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
        return currentWithoutLocale
    }
    
    class func currentAppleLanguageFull() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}
