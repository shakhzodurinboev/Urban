//
//  WarningViewController.swift
//  Urban
//
//  Created by Khusan on 25.02.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {

    
    @IBAction func exitButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
