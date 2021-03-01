//
//  MapViewController.swift
//  Urban
//
//  Created by Khusan on 05.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Reachability

class MapViewController: MapViewControllerFuncs, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    
    private let manager = CLLocationManager()
    static var selectedAnnotation: MKPointAnnotation?
    static var selectedIndex: String?
    static var usersCurrentLoc: CLLocation!
    private let reachability = try! Reachability()
    private let pullUpController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapInfoViewController") as? MapInfoViewController
    
    @IBAction func locationButtonAction(_ sender: Any) {
        manager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        reachability.whenReachable = { _ in
            self.activityIndicator.startAnimating()
            self.getFilials(connected: { (connected) -> (Void) in
                if connected == true {
                    for i in 0..<self.totalCount {
                        print(MapViewControllerFuncs.lattitude[i])
                        let CLLCoordType = CLLocationCoordinate2D(latitude: (MapViewControllerFuncs.lattitude[i] as NSString).doubleValue, longitude: (MapViewControllerFuncs.longtitude[i] as NSString).doubleValue)
                        let anno = MKPointAnnotation()
                        anno.coordinate = CLLCoordType
                        anno.title = String(i)
                        self.map.addAnnotation(anno)
                    }
                    self.activityIndicator.stopAnimating()
                } else {
                    
                }
            })
        }
        reachability.whenUnreachable = { _ in
            print("don't have internet connection")
            self.noInternetConnection()
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        MapViewController.usersCurrentLoc = location
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        manager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            //let pinImage = UIImage(named: "annotation.png")
            annotationView?.image = UIImage(named: "annotation.png")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            
        } else {
            MapViewController.selectedAnnotation = view.annotation as? MKPointAnnotation
            MapViewController.selectedIndex = view.annotation?.title as? String
            let pinImage = UIImage(named: "annotation.png")
            let size = CGSize(width: 25.5, height: 30.5)
            UIGraphicsBeginImageContext(size)
            pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            _ = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            //view.image = resizedImage
            view.image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            addPullUpController(pullUpController!)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            
        } else {
            view.image = UIImage(named: "annotation.png")
            removePullUpController(pullUpController!)
        }
    }
    
    func initial() {
        map.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "DaysOne-Regular", size: 15)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        map.showsUserLocation = false
        map.tintColor = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)
        locationButton.layer.borderWidth = 0.3
        locationButton.layer.borderColor = UIColor.gray.cgColor
        locationButton.layer.cornerRadius = 7
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
