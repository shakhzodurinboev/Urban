//
//  HistoryTableViewCell.swift
//  Urban
//
//  Created by Khusan on 02.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var firstStack: UIView!
    @IBOutlet weak var dateOfBuy: UILabel!
    @IBOutlet weak var nameOfProduct: UILabel!
    @IBOutlet weak var addressOfShop: UILabel!
    @IBOutlet weak var articulOfProduct: UILabel!
    @IBOutlet weak var chequeNumber: UILabel!
    @IBOutlet weak var typeOfProduct: UILabel!
    @IBOutlet weak var sizeOfProduct: UILabel!
    @IBOutlet weak var colorOfProduct: UILabel!
    
    @IBOutlet weak var cash: UILabel!
    @IBOutlet weak var card: UILabel!
    @IBOutlet weak var cardStack: UIStackView!
    @IBOutlet weak var cashback: UILabel!
    
    @IBOutlet weak var resultSum: UILabel!
    @IBOutlet weak var resultCashback: UILabel!
    
    @IBOutlet weak var secondStack: UIView!
    @IBOutlet weak var thirdStack: UIView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightOfFirstView: NSLayoutConstraint!
    @IBOutlet weak var hideTextLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
