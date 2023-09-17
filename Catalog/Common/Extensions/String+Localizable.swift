//
//  String+Localizable.swift
//  Catalog
//
//  Created by Pedro Solís García on 03/07/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}
