//
//  UIRectCorner+Side.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/08/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

extension UIRectCorner {
    static let all: UIRectCorner = [.bottom, .top]
    static let bottom: UIRectCorner = [.bottomLeft, .bottomRight]
    static let top: UIRectCorner = [.topLeft, .topRight]
}
