//
//  DressesMapper.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/09/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

class DressesMapper {
    
    static func mapToDresses(_ dresses: [CollectionDresses]) -> [Dress] {
        return dresses.map {
            Dress(
                name: $0.name,
                image: UIImage(data: $0.imageData!)!
            )
        }
    }
}
