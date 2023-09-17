//
//  ClientDataValidator.swift
//  Catalog
//
//  Created by Pedro Solís García on 09/08/18.
//  Copyright © 2018 VILHON Technologies. All rights reserved.
//

import Foundation

class ClientDataValidator {
    
    static func validate(name: String, surname: String, region: String, weddingDate: String) -> Bool {
        return validateClientName(name: name)
        && validateClientName(name: surname)
        && validateField(field: region)
        && validateField(field: weddingDate)
    }
    
    static func validateField(field: String) -> Bool {
        return field != ""
    }
    
    static func validateClientName(name: String) -> Bool {
        let RegEx: String = "\\A\\w{0,25}(\\s+\\w{0,25})?"
        let Test = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return Test.evaluate(with:name)
    }
}
