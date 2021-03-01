//
//  BrandsCollectionViewCell.swift
//  Urban
//
//  Created by Khusan on 05.01.2018.
//  Copyright © 2018 GlobalSolutions. All rights reserved.
//

import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandsImgView: UIView!
    @IBOutlet weak var brandsImg: UIImageView!
    
    override func awakeFromNib() {
        brandsImgView.layer.cornerRadius = 4
        brandsImgView.layer.borderWidth = 1
        brandsImgView.layer.borderColor = UIColor.lightGray.cgColor
        brandsImgView.layer.masksToBounds = true
        brandsImg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
