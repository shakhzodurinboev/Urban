//
//  CongratulationsViewController.swift
//  Urban
//
//  Created by Khusan on 01.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class CongratulationsViewController: UIViewController {

    @IBOutlet weak var enterButtonOutlet: UIButton!
    @IBOutlet weak var ballonsImageOutlet: UIImageView!
    @IBOutlet weak var congratulationsLabel: UILabel!
    @IBOutlet weak var congratulationsMainTextLabel: UILabel!
    @IBOutlet weak var cardImageOutlet: UIImageView!
    @IBOutlet weak var cardMainTextLabel: UILabel!
    
    private let paragraphStyle = NSMutableParagraphStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        UserDefaults.standard.set(true, forKey: "UserIsLogged")
    }
    
    func initial() {
        let congratulationsText = NSMutableAttributedString(string: congratulationsMainTextLabel.text!)
        congratulationsText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, congratulationsText.length))
        paragraphStyle.lineSpacing = 5
        do {
            let regex = try NSRegularExpression(pattern: "(5%[A-Za-z0-9]*)", options: [])
            let matches = regex.matches(in: congratulationsMainTextLabel.text!, options:[], range:NSMakeRange(0, congratulationsMainTextLabel.text!.count))
            for match in matches {
                congratulationsText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Ubuntu-Medium", size: 16)! , range: match.range)
            }
        } catch {
            
        }
        congratulationsMainTextLabel.attributedText = congratulationsText
        congratulationsMainTextLabel.textAlignment = NSTextAlignment.center
        
        let cardText = NSMutableAttributedString(string: cardMainTextLabel.text!)
        cardText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, cardText.length))
        cardMainTextLabel.attributedText = cardText
        cardMainTextLabel.textAlignment = NSTextAlignment.center
    }
}
