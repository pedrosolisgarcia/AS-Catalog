//
//  UIView+DisplayAnimated.swift
//  Catalog
//
//  Created by Pedro Solís García on 19/06/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAnimated() -> Void {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimated() -> Void {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
                self.dismiss(animated: false)
            }
        });
    }
}
