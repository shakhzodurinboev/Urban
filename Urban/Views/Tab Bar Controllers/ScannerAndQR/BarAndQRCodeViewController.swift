//
//  BarAndQRCodeViewController.swift
//  Urban
//
//  Created by Khusan on 11.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class BarAndQRCodeViewController: UIViewController {

    @IBOutlet weak var customNavigationItem: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    static var selectedSegment:Int = 0
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            navigationTitle.text = "ВАШ QR КОД"
            add(asChildViewController: QRCode)
            remove(asChildViewController: barCode)
        } else {
            navigationTitle.text = "СКАНЕР"
            add(asChildViewController: barCode)
            remove(asChildViewController: QRCode)
        }
    }
    
    private lazy var QRCode: QRCodeViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var barCode: BarCodeScannerViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "BarCodeScannerViewController") as! BarCodeScannerViewController
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentOutlet.selectedSegmentIndex = BarAndQRCodeViewController.selectedSegment
        if segmentOutlet.selectedSegmentIndex == 0 {
            navigationTitle.text = "ВАШ QR КОД"
            add(asChildViewController: QRCode)
            remove(asChildViewController: barCode)
        } else {
            navigationTitle.text = "СКАНЕР"
            add(asChildViewController: barCode)
            remove(asChildViewController: QRCode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        customNavigationItem.borders(for: [UIRectEdge.bottom], width: 0.5, color: .gray)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
