//
//  BrandsViewController.swift
//  Urban
//
//  Created by Khusan on 05.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Kingfisher
import Reachability

class BrandsViewController: BrandsViewControllerFuncs, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    let reachability = try! Reachability()
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! BrandsCollectionViewCell
        cell.brandsImg.kf.setImage(with: URL(string: String(describing: self.pictureURL[indexPath.row][0])))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.shared.openURL(URL(string: "https://www.\(link[indexPath.row])")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        reachability.whenReachable = { _ in
            self.getBrands(connected: { (connected) -> (Void) in
                if connected == true {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.brandsCollectionView.reloadData()
                } else {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            })
        }
        reachability.whenUnreachable = { _ in
            print("don't have internet connection")
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if let totalCount = UserDefaults.standard.object(forKey: "brandsTotalCount"), let pictureURL = UserDefaults.standard.object(forKey: "brandspictureURL"), let link = UserDefaults.standard.object(forKey: "brandslink") {
                self.totalCount = totalCount as! Int
                self.pictureURL = pictureURL as! [[String]]
                self.link = link as! [String]
                self.brandsCollectionView.reloadData()
            }
            self.noInternetConnection()
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func initial() {
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "DaysOne-Regular", size: 15)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
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
