//
//  UIView+RoundCorners.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/08/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(from side: UIRectCorner, radius: Double) -> Void {
        let maskPathSave = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: side, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayerSave = CAShapeLayer()
        maskLayerSave.path = maskPathSave.cgPath
        self.layer.mask = maskLayerSave
    }
}
