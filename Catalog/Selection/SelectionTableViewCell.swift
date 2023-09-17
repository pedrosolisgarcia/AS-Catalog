//
//  SelectionTableViewCell.swift
//  Catalog
//
//  Created by Pedro Solís García on 15/10/17.
//  Copyright © 2017 VILHON Technologies. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dressImageView: UIImageView!
    @IBOutlet weak var dressLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
