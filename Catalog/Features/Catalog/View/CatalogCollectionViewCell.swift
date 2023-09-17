//
//  CatalogCollectionViewCell.swift
//  Catalog
//
//  Created by Pedro Solís García on 26/09/17.
//  Copyright © 2017 VILHON Technologies. All rights reserved.
//

import UIKit

protocol CatalogCollectionViewCellZoomable: AnyObject {
    func zoomCell(_ sender: UIButton)
}

class CatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dressImageView: UIImageView!
    @IBOutlet weak var dressLabel: UILabel!
    @IBOutlet weak var selectedFlag: UIImageView!
    weak var cellDelegate: CatalogCollectionViewCellZoomable?
    
    @IBAction func buttonPressed(_ sender: UIButton) -> Void {
        cellDelegate?.zoomCell(sender)
    }
    
    func configure(_ viewModel: DressViewModel) {
        self.dressImageView.image = viewModel.image
        self.dressLabel.font = UIFont(name: "TrajanPro-Regular", size: 22)
        self.dressLabel.text = viewModel.name
    }
    
    override var isSelected: Bool {
        didSet {
            self.selectedFlag.image = isSelected ? UIImage(named: "tick") : nil
            self.dressLabel.backgroundColor = isSelected ? UIColor.catalogGolden.barelyTranslucent() : UIColor.black.veryTranslucent()
        }
    }
}
