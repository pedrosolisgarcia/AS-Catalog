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
    var lastname: String
    var email: String
    var phone: String
    var city: String
    var weddingDate: String
    var dresses: [String]
    
    init(name: String, lastname: String, email: String, phone: String, city: String, weddingDate: String,dresses: [String]){
        self.name = name
        self.lastname = lastname
        self.email = email
        self.phone = phone
        self.city = city
        self.weddingDate = weddingDate
        self.dresses = dresses
    }
}
