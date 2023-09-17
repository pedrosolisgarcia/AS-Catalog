//
//  UIViewController+AddBlurView.swift
//  Catalog
//
//  Created by Pedro Solís García on 02/07/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

extension UIViewController {
    func addBlurView(below subView: UIView) -> Void {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        self.view.insertSubview(blurEffectView, belowSubview: subView)
    }
}
