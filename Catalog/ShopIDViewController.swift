//
//  ShopIDViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 06/08/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class ShopIDViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shopIdField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var shopIdView: UIView!
    
    var languageIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = ShopIdManager.isThereAnyShopIdRegisteredAlready() ?
            LocalData.getLocalizationLabels(forElement: "headerLabel_ID_Identified")[languageIndex] + ShopIdManager.retrieveIPadShopId()! :
            LocalData.getLocalizationLabels(forElement: "headerLabel_ID")[languageIndex]
        cancelButton.setTitle(LocalData.getLocalizationLabels(forElement: "cancelButton")[languageIndex], for: .normal)
        confirmButton.setTitle(LocalData.getLocalizationLabels(forElement: "confirmButton")[languageIndex], for: .normal)
        
        if !ShopIdManager.isThereAnyShopIdRegisteredAlready() {
            cancelButton.isEnabled = false
            cancelButton.isHidden = true
        }
        
        let maskPathSave = UIBezierPath(roundedRect: confirmButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayerSave = CAShapeLayer()
        maskLayerSave.path = maskPathSave.cgPath
        confirmButton.layer.mask = maskLayerSave
        
        let maskPathLabel = UIBezierPath(roundedRect: headerLabel.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayerLabel = CAShapeLayer()
        maskLayerLabel.path = maskPathLabel.cgPath
        headerLabel.layer.mask = maskLayerLabel
        
        addBlurView()
        self.showAnimate()
    }
    
    func addBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        self.view.insertSubview(blurEffectView, belowSubview: shopIdView)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate() {
        
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
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
    
    @IBAction func removeAnimate(sender: UIButton) {
        
        if (sender == self.confirmButton) {
            if self.tryToSaveShopId() {
                self.removeAnimate()
            } else {
                let alertController = UIAlertController(title: LocalData.getLocalizationLabels(forElement: "warningTitle")[languageIndex], message: LocalData.getLocalizationLabels(forElement: "warningMessage_ID")[languageIndex], preferredStyle: .alert)
                let alertAction = UIAlertAction(title: LocalData.getLocalizationLabels(forElement: "warningButton")[languageIndex], style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion:nil)
                self.shopIdField.text = ""
            }
        }
        if (sender == self.cancelButton) {
            self.removeAnimate()
        }

    }
    
    func tryToSaveShopId() -> Bool {
        if (ShopIdManager.validShopIds().contains(self.shopIdField.text!.uppercased())) {
            return (nil != ShopIdManager.saveShopIdInIPad(shopId: self.shopIdField.text!.uppercased()))
        }
        return false;
    }

}
