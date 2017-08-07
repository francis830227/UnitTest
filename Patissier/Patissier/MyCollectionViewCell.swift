//
//  MyCollectionViewCell.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/6/22.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit

public class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myProduct: UIView!

    @IBOutlet weak var product: UIView!
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var backgroundShadow: UIView!
    @IBOutlet weak var productImage: UIImageView!

}
