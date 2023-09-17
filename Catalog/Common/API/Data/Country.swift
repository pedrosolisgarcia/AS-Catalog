//
//  Country.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/08/18.
//  Copyright © 2018 VILHON Technologies. All rights reserved.
//

import Foundation

public struct Country: Codable {
    var name: String = ""
    var imgName: String = ""
    
    init(name: String, imgName: String){
        self.name = name
        self.imgName = imgName
    }
}
