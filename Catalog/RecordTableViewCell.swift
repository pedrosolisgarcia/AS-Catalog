//
//  RecordTableViewCell.swift
//  Catalog
//
//  Created by Pedro Solís García on 23/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lastnameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weddingDateLabel: UILabel!
    @IBOutlet var dressesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
