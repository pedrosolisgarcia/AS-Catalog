//
//  UIViewController+DisplayAlerts.swift
//  Catalog
//
//  Created by Pedro Solís García on 07/08/20.
//  Copyright © 2020 VILHON Technologies. All rights reserved.
//

import UIKit

extension UIViewController {
    func displaySingleActionAlert(
        title: String,
        message: String,
        actionTitle: String,
        action: ((UIAlertAction) -> Void)?
    ) -> Void {
        let alertController = UIAlertController(
            title: title.localized(),
            message: message.localized(),
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: actionTitle.localized(),
            style: .default,
            handler: action
        )
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
