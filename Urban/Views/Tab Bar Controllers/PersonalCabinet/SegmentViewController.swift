//
//  SegmentViewController.swift
//  Urban
//
//  Created by Khusan on 02.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class SegmentViewController: UIViewController {
    
    @IBOutlet weak var customNavigationItem: UIView!
    @IBOutlet weak var personalCabinetLabel: UILabel!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            add(asChildViewController: personalCabinet)
            remove(asChildViewController: history)
        } else {
            add(asChildViewController: history)
            remove(asChildViewController: personalCabinet)
        }
    }
    
    private lazy var personalCabinet: PersonalCabinetViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "PersonalCabinetViewController") as! PersonalCabinetViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var history: HistoryViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        customNavigationItem.borders(for: [UIRectEdge.bottom], width: 0.5, color: .gray)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        add(asChildViewController: personalCabinet)
    }
    
    func initial() {
        //customNavigationItem
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
}
