//
//  BarCodeScannerViewController.swift
//  Urban
//
//  Created by Khusan on 07.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeScannerViewController: BarCodeScannerViewControllerFuncs {
    
    @IBOutlet weak var cameraView: UIView! {
        didSet {
            cameraView.layer.mask = maskLayer
        }
    }
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var text: UILabel!
    
    lazy var scanBarcodeCameraManager: ScanBarcodeCameraManager = {
        let this = ScanBarcodeCameraManager()
        this.delegate = self
        return this
    }()
    lazy var maskLayer: CALayer = {
        let this = CALayer()
        this.backgroundColor = UIColor(red: 0/255,
                                       green: 0/255,
                                       blue: 0/255,
                                       alpha: 0.5).cgColor
        this.addSublayer(rectLayer)
        return this
    }()
    lazy var rectLayer: CAShapeLayer = {
        let this = CAShapeLayer()
        this.fillColor = UIColor.black.cgColor
        this.strokeColor = UIColor.white.cgColor
        return this
    }()
    
    lazy var rectPath: UIBezierPath = {
        let this = UIBezierPath()
        return this
    }()
    
    lazy var useFrontTextLayer: CATextLayer = {
        let this = CATextLayer()
        return this
    }()
    
    lazy var tapHereToCaptureTextLayer: CATextLayer = {
        let this = CATextLayer()
        return this
    }()
    private var scannedImg = UIImage()
    private var barcode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanBarcodeCameraManager.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanBarcodeCameraManager.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        scanBarcodeCameraManager.transitionCamera()
    }
    
    override func viewDidLayoutSubviews() {
        self.scanBarcodeCameraManager.updatePreviewFrame()
        drawOverRectView()
    }
    
    /**
     this func will draw a rect mask over the camera view
     */
    func drawOverRectView() {
        cameraView.layer.mask = nil
        let cameraSize = self.cameraView!.frame.size
        /// to calculate the height of frame based on screen size
        var frameHeight: CGFloat = 0.0
        /// to calculate the width of frame based on screen size
        var frameWidth: CGFloat =  0.0
        /// to calculate position Y of recFrame to be in center of cameraView
        var originY: CGFloat = 0.0
        /// to calculate position X of recFrame to be in center of cameraView
        var originX: CGFloat = 0.0
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        // calculatin position and frame of rectFrame based on screen size
        switch (orientation) {
        case .landscapeRight, .landscapeLeft:
            frameHeight = (cameraSize.height)/1.4 - 80
            frameWidth = cameraSize.width///1.5
            originY = ((cameraSize.height - frameHeight)/2)
            originX = (cameraSize.width - frameWidth)/2
            break
        default:
            //if it is faceUp or portrait or any other orientation
            frameHeight = (cameraSize.height)/1.5 - 80
            frameWidth = cameraSize.width///1.15
            originY = ((cameraSize.height - frameHeight)/2)
            originX = (cameraSize.width - frameWidth)/2
            break
        }
        //create a rect shape layer
        rectLayer.frame = CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight)
        //create a beizier path for a rounded rectangle
        rectPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight), cornerRadius: 0)
        //add beizier to rect shapelayer
        rectLayer.path = rectPath.cgPath
        rectLayer.fillColor = UIColor.black.cgColor
        rectLayer.strokeColor = UIColor.white.cgColor
        //add shapelayer to layer
        maskLayer.frame = cameraView.bounds
        maskLayer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        maskLayer.addSublayer(rectLayer)
        //add layer mask to camera view
        cameraView.layer.mask = maskLayer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanFinished" {
            let vc = segue.destination as? ProductViewController
            vc?.scannedImage = self.scannedImg
            if barcode.first == "0" {
                barcode.removeFirst()
            }
            vc?.barcode = self.barcode
        }
    }
}

// MARK: - InitView
extension BarCodeScannerViewController: ScanBarcodeCameraManagerDelegate {
    func scanBarcodeCameraManagerDidRecognizeBarcode(barcode: [AVMetadataMachineReadableCodeObject], image: UIImage?, code: String) {
        self.scanBarcodeCameraManager.stopRunning()
        self.barcode = code
        self.scannedImg = image!
        self.performSegue(withIdentifier: "scanFinished", sender: self)
    }
    
    func initView() {
        do {
            try scanBarcodeCameraManager.captureSetup(in: self.cameraView, with: .back)
        } catch {
            let alertController = UIAlertController(title: NSLocalizedString("Произошла ошибка", comment: "Пожалуйста, повторите заного"),
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            alertController.addAction(.init(title: "ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        self.cameraView.addSubview(textView)
    }
}
