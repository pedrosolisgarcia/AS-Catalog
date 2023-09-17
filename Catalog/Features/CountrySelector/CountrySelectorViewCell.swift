//
//  CountrySelectorViewCell.swift
//  Catalog
//
//  Created by Pedro Solís García on 30/01/18.
//  Copyright © 2018 VILHON Technologies. All rights reserved.
//

import UIKit

class CountrySelectorViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = UIColor.catalogGolden.barelyTranslucent()
                self.countryLabel.textColor = .white
                self.countryFlag.alpha = 0.5
            }
            else {
                self.contentView.backgroundColor = .white
                self.countryLabel.textColor = .black
                self.countryFlag.alpha = 1
            }
        }
    }
}
