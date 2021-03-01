//
//  NewsViewController.swift
//  Urban
//
//  Created by Khusan on 07.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import Reachability
import MobilePlayer

class NewsViewController: NewsViewControllerFuncs, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var customNavigationItem: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private let reachability = try! Reachability()
    private var storedOffsets = [Int: CGFloat]()
    private var category:String = "all"
    private var page:Int = 1
    
    @IBAction func categorySegmentAction(_ sender: UISegmentedControl) {
        tableView.isHidden = true
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        if sender.selectedSegmentIndex == 0 {
            self.category = "all"
        } else if sender.selectedSegmentIndex == 1 {
            self.category = "men"
        } else if sender.selectedSegmentIndex == 2 {
            self.category = "women"
        } else {
            self.category = "kids"
        }
        self.getNews(category: self.category, connected: { (connected) -> (Void) in
            if connected == true {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                if self.tableView.numberOfRows(inSection: 0) > 0 {
                    self.tableView.scrollToRow(at:  IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                UIApplication.shared.endIgnoringInteractionEvents()
                self.reachability.stopNotifier()
            } else {
                if self.category == "all" {
                    if self.page == 1, let id = UserDefaults.standard.object(forKey: "idInNews"), let labelOfProduct = UserDefaults.standard.object(forKey: "labelOfProductInNews"), let nameOfProduct = UserDefaults.standard.object(forKey: "nameOfProductInNews"), let descriptionOfProduct = UserDefaults.standard.object(forKey: "descriptionOfProductInNews"), let priceOfProduct = UserDefaults.standard.object(forKey: "priceOfProductInNews"), let imgURLOfProduct = UserDefaults.standard.object(forKey: "imgURLOfProductInNews"), let videoURLOfProduct = UserDefaults.standard.object(forKey: "videoURLOfProductInNews") {
                        self.id = id as! Int
                        self.labelOfProduct = labelOfProduct as! [String]
                        self.nameOfProduct = nameOfProduct as! [String]
                        self.descriptionOfProduct = descriptionOfProduct as! [String]
                        self.priceOfProduct = priceOfProduct as! [String]
                        self.imgURLOfProduct = imgURLOfProduct as! [[String]]
                        self.videoURLOfProduct = videoURLOfProduct as! [String]
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.reachability.stopNotifier()
                    } else {
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.noInternetConnection()
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.noInternetConnection()
                }
            }
        })
    }
    
    @IBAction func shareButtonAction(_ sender: AnyObject) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        guard let cell = sender.superview??.superview as? TableViewCell else { return }
        let indexPath = tableView.indexPath(for: cell)
        print(indexPath!.row)
        if let url = URL.init(string: String(describing: self.imgURLOfProduct[indexPath!.row][0])) {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData:NSData = NSData(contentsOf: url)!
                let imageView = UIImageView()
                // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    imageView.image = image
                    let shareText = "\(NSLocalizedString("Рекомендую", comment: "Рекомендую")) \(cell.nameOfProduct.text!) (\(cell.priceOfProduct.text!) \(NSLocalizedString("сум", comment: "сум"))) \n\(NSLocalizedString("Отправлено с Urban App iOS", comment: "Отправлено с Urban App iOS")) - https://itunes.apple.com/us/app/urban/id1357257803?l=ru&ls=1&mt=8"
                    let vc = UIActivityViewController(activityItems: [shareText, image!], applicationActivities: [])
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    //////Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return id
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        cell.labelOfProduct.text = self.labelOfProduct[indexPath.row]
        if priceOfProduct[indexPath.row].isEmpty {
            cell.priceOfProduct.isHidden = true
            cell.sum.isHidden = true
        } else {
            cell.priceOfProduct.isHidden = false
            cell.sum.isHidden = false
            cell.priceOfProduct.text = self.priceOfProduct[indexPath.row]
        }
        
        let text:String = "\(self.nameOfProduct[indexPath.row]) - \(self.descriptionOfProduct[indexPath.row])"
        if let idx = text.firstIndex(of: "-") {
            let first = text.substring(to: idx)
            var attrText = NSMutableAttributedString()
            attrText = NSMutableAttributedString(string: text as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Ubuntu-Medium", size: 16.0)!])
            let firstColor = UIColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1)
            attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor, range: NSRange(location: 0, length: first.count))
            cell.nameOfProduct.attributedText = attrText
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    //////Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgURLOfProduct[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: String(describing: self.imgURLOfProduct[collectionView.tag][indexPath.item])))
        if self.videoURLOfProduct[collectionView.tag].isEmpty == true {
            cell.videoPlayerButton.isHidden = true
        } else {
            cell.videoPlayerButton.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        if self.videoURLOfProduct[collectionView.tag].isEmpty {
            
        } else {
            let videoURL = URL(string: self.videoURLOfProduct[collectionView.tag])
            let playerVC = MobilePlayerViewController(contentURL: videoURL!)
            playerVC.title = "\(self.nameOfProduct[indexPath.row])"
            playerVC.activityItems = [videoURL!]
            presentMoviePlayerViewControllerAnimated(playerVC)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.imgURLOfProduct[collectionView.tag].count == 1 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.size.width - 38, height: collectionView.frame.size.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reachability.whenReachable = { _ in
            self.tableView.isHidden = true
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.getNews(category: self.category, connected: { (connected) -> (Void) in
                if connected == true {
                    self.activityIndicator.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.reachability.stopNotifier()
                } else {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            })
        }
        reachability.whenUnreachable = { _ in
            self.tableView.isHidden = true
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            if self.page == 1, let id = UserDefaults.standard.object(forKey: "idInNews"), let labelOfProduct = UserDefaults.standard.object(forKey: "labelOfProductInNews"), let nameOfProduct = UserDefaults.standard.object(forKey: "nameOfProductInNews"), let descriptionOfProduct = UserDefaults.standard.object(forKey: "descriptionOfProductInNews"), let priceOfProduct = UserDefaults.standard.object(forKey: "priceOfProductInNews"), let imgURLOfProduct = UserDefaults.standard.object(forKey: "imgURLOfProductInNews"), let videoURLOfProduct = UserDefaults.standard.object(forKey: "videoURLOfProductInNews") {
                self.id = id as! Int
                self.labelOfProduct = labelOfProduct as! [String]
                self.nameOfProduct = nameOfProduct as! [String]
                self.descriptionOfProduct = descriptionOfProduct as! [String]
                self.priceOfProduct = priceOfProduct as! [String]
                self.imgURLOfProduct = imgURLOfProduct as! [[String]]
                self.videoURLOfProduct = videoURLOfProduct as! [String]
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.reachability.stopNotifier()
            } else {
                self.activityIndicator.stopAnimating()
                self.noInternetConnection()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customNavigationItem.borders(for: [UIRectEdge.bottom], width: 0.5, color: .gray)
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
