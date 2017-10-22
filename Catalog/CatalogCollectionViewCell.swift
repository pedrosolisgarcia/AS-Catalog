//
//  CatalogCollectionViewCell.swift
//  Catalog
//
//  Created by Pedro Solís García on 26/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

protocol CatalogCollectionViewCellDelegate: class {
    func didPressZoomButton(_ sender: UIButton)
}

class CatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var dressImageView: UIImageView!
    @IBOutlet var dressLabel: UILabel!
    @IBOutlet var selectedFlag: UIImageView!
    weak var cellDelegate: CatalogCollectionViewCellDelegate?
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        cellDelegate?.didPressZoomButton(sender)
    }
    
    override var isSelected: Bool {
        didSet {
            
            // In case the cell is selected
            self.selectedFlag.image = isSelected ? UIImage(named: "tick") : nil
            self.dressLabel.backgroundColor = isSelected ? UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 0.75) : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        }
    }
}
