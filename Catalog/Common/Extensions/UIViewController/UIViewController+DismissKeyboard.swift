//
//  UIView+DismissKeyboard.swift
//  Catalog
//
//  Created by Pedro Solís García on 21/06/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

extension UIView {
    func addDismissKeyboardListener() -> Void {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
}
