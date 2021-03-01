//
//  TabBarViewController.swift
//  Urban
//
//  Created by Khusan on 06.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    static var tabBarId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.selectedIndex = TabBarViewController.tabBarId
    }
}
