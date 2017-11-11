//
//  SelectionTableViewCell.swift
//  Catalog
//
//  Created by Pedro Solís García on 15/10/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dressImageView: UIImageView!
    @IBOutlet weak var dressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
