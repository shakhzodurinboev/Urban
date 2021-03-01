//
//  MapInfoViewController.swift
//  Urban
//
//  Created by Khusan on 06.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import MapKit

class MapInfoViewController: PullUpController {
    
    @IBOutlet weak var mainView: RoundCornersView!
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.layer.cornerRadius = separatorView.frame.height/2
        }
    }
    @IBOutlet private weak var firstPreviewView: UIView!
    @IBOutlet weak var distanceView: Triangle!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameOfStore: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet private weak var secondPreviewView: UIView!
    @IBOutlet weak var operOrCloseLabel: UILabel!
    @IBOutlet weak var fromMonToFriTime: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBAction func directionButtonAction(_ sender: Any) {
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegion(center: (MapViewController.selectedAnnotation?.coordinate)!, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        if #available(iOS 10.0, *) {
            let placemark = MKPlacemark(coordinate: (MapViewController.selectedAnnotation?.coordinate)!)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Urban Store"
            mapItem.openInMaps(launchOptions: options)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func phoneButtonAction(_ sender: Any) {
        let number:Int = Int(phoneNumber.text!.removingWhitespaces())!
        if let url = URL(string: "tel://+\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initial()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        phoneButton.layer.cornerRadius = phoneButton.frame.size.width / 2
        phoneButton.layer.borderColor = UIColor.lightGray.cgColor
        phoneButton.layer.borderWidth = 0.3
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 15 + secondPreviewView.frame.maxY)
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        return 15 + firstPreviewView.frame.height
    }
    
    override var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 5, y: 5, width: 280, height: UIScreen.main.bounds.height - 10)
    }

    func initial() {
        let index = Int(MapViewController.selectedIndex!)!
        let selectedCoord = CLLocation(latitude: (MapViewControllerFuncs.lattitude[index] as NSString).doubleValue, longitude: (MapViewControllerFuncs.longtitude[index] as NSString).doubleValue)
        distanceLabel.text = "\(Int(selectedCoord.distance(from: MapViewController.usersCurrentLoc))) м"
        nameOfStore.text = MapViewControllerFuncs.name[index]
        addressLabel.text = MapViewControllerFuncs.address[index]
        /*if getTodayString()[0] == "1" {
            self.operOrCloseLabel.textColor = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)
            self.operOrCloseLabel.text = NSLocalizedString("Закрыто", comment: "Закрыто")
        } else if getTodayString()[0] == "7" {
            if getTodayString()[1] >= MapViewControllerFuncs.satTime[index]["from"].stringValue && getTodayString()[1] <= MapViewControllerFuncs.satTime[index]["to"].stringValue {
                print(getTodayString()[1])
                self.operOrCloseLabel.textColor = UIColor(red: 11.0/255.0, green: 223.0/255.0, blue: 41.0/255.0, alpha: 1)
                self.operOrCloseLabel.text = NSLocalizedString("Открыто", comment: "Открыто")
            } else {
                self.operOrCloseLabel.textColor = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)
                self.operOrCloseLabel.text = NSLocalizedString("Закрыто", comment: "Закрыто")
            }
        } else {
            if getTodayString()[1] >= MapViewControllerFuncs.monTime[index]["from"].stringValue && getTodayString()[1] <= MapViewControllerFuncs.monTime[index]["to"].stringValue {
                self.operOrCloseLabel.textColor = UIColor(red: 11.0/255.0, green: 223.0/255.0, blue: 41.0/255.0, alpha: 1)
                self.operOrCloseLabel.text = NSLocalizedString("Открыто", comment: "Открыто")
            } else {
                self.operOrCloseLabel.textColor = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)
                self.operOrCloseLabel.text = NSLocalizedString("Закрыто", comment: "Закрыто")
            }
        }*/
        if getTodayString()[1] >= MapViewControllerFuncs.monTime[index]["from"].stringValue && getTodayString()[1] <= MapViewControllerFuncs.monTime[index]["to"].stringValue {
            print("hello 1")
            self.operOrCloseLabel.textColor = UIColor(red: 11.0/255.0, green: 223.0/255.0, blue: 41.0/255.0, alpha: 1)
            self.operOrCloseLabel.text = NSLocalizedString("Открыто", comment: "Открыто")
        } else {
            print("hello 2")
            self.operOrCloseLabel.textColor = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)
            self.operOrCloseLabel.text = NSLocalizedString("Закрыто", comment: "Закрыто")
        }
        self.fromMonToFriTime.text = "\(NSLocalizedString("с", comment: "с")) \(MapViewControllerFuncs.monTime[index]["from"].stringValue) \(NSLocalizedString("до", comment: "до")) \(MapViewControllerFuncs.monTime[index]["to"].stringValue)"
        self.phoneNumber.text = MapViewControllerFuncs.phoneNumber[index]
    }
    
    func getTodayString() -> [String] {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: date)
        let today = "\(components.year!)-\(components.month!)-\(components.day!)"
        let currentHour = "\(components.hour!):\(components.minute!)"
        var data = [String]()
        data.append(String(describing: getDayOfWeek(today)))
        data.append(currentHour)
        return data
    }
    
    func getDayOfWeek(_ today:String) -> Int {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate!)
        return weekDay
    }
}

