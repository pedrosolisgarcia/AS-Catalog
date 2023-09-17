//
//  DressViewModel.swift
//  Catalog
//
//  Created by Pedro Solís García on 09/07/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

struct DressViewModel {
    let name: String
    let image: UIImage
    
    init(dress: Dress) {
        name = dress.name
        image = dress.image
    }
}
