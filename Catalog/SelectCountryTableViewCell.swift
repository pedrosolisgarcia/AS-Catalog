//
//  SelectCountryTableViewCell.swift
//  Catalog
//
//  Created by Pedro Solís García on 30/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class SelectCountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.contentView.backgroundColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 0.75)
            self.countryLabel.textColor = UIColor.white
        }
        else {
            self.contentView.backgroundColor = UIColor.white
            self.countryLabel.textColor = UIColor.black
        }
    }
}
