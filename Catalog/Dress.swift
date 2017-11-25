//
//  Dress.swift
//  Catalog
//
//  Created by Pedro Solís García on 26/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

struct Dress {
    var name: String = ""
    var imgName: String = ""
    var isSelected: Bool = false
    
    init(name: String, imgName: String, isSelected: Bool){
        self.name = name
        self.imgName = imgName
        self.isSelected = isSelected
    }
}
