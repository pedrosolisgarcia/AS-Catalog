//
//  RecordTableViewCell.swift
//  Catalog
//
//  Created by Pedro Solís García on 23/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityCount: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthCount: UILabel!
    @IBOutlet weak var dressLabel: UILabel!
    @IBOutlet weak var dressCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
