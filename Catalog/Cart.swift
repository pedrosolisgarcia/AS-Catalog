//
//  User.swift
//  Catalog
//
//  Created by Pedro Solís García on 14/10/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

struct Cart {
    var name: String
    var surname: String
    var region: String
    var dateOfWedding: String
    var dressesNames: [String]
    
    init(name: String, surname: String, region: String, dateOfWedding: String, dressesNames: [String]){
        self.name = name
        self.surname = surname
        self.region = region
        self.dateOfWedding = dateOfWedding
        self.dressesNames = dressesNames
    }
}
