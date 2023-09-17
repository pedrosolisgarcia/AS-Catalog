//
//  UIColor+Opacity.swift
//  Catalog
//
//  Created by Pedro Solís García on 03/07/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

extension UIColor {
    func veryTranslucent() -> UIColor {
        return self.withAlphaComponent(0.25)
    }
    
    func midTranslucent() -> UIColor {
        return self.withAlphaComponent(0.5)
    }
    
    func barelyTranslucent() -> UIColor {
        return self.withAlphaComponent(0.75)
    }
}
