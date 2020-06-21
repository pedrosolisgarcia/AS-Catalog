//
//  CollectionCheckViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 20/06/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class CollectionCheckViewController: UIViewController {

  @IBOutlet weak var collectionCheckLabel: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var textTop: UILabel!
  @IBOutlet weak var collectionLabel: UILabel!
  @IBOutlet weak var textBottom: UILabel!
  @IBOutlet weak var downloadButton: UIButton!
  @IBOutlet weak var collectionCheckView: UIView!
  
  var languageIndex: Int!

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionCheckLabel.text = LocalData.getLocalizationLabels(forElement: "collectionCheckLabel")[languageIndex]
    cancelButton.setTitle(LocalData.getLocalizationLabels(forElement: "cancelButton")[languageIndex], for: .normal)
    textTop.text = LocalData.getLocalizationLabels(forElement: "collectionCheckTextTop")[languageIndex]
    textBottom.text = LocalData.getLocalizationLabels(forElement: "collectionCheckTextBottom")[languageIndex]
    downloadButton.setTitle(LocalData.getLocalizationLabels(forElement: "collectionCheckButton")[languageIndex], for: .normal)
    
    if !ShopIdManager.isThereAnyShopIdRegisteredAlready() {
      cancelButton.isEnabled = false
      cancelButton.isHidden = true
    }
    
    let maskPathSave = UIBezierPath(roundedRect: downloadButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
    
    let maskLayerSave = CAShapeLayer()
    maskLayerSave.path = maskPathSave.cgPath
    downloadButton.layer.mask = maskLayerSave
    
    let maskPathLabel = UIBezierPath(roundedRect: collectionCheckLabel.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
    
    let maskLayerLabel = CAShapeLayer()
    maskLayerLabel.path = maskPathLabel.cgPath
    collectionCheckLabel.layer.mask = maskLayerLabel
    
    self.showAnimated()
  }
  
  @IBAction func removeAnimate(sender: UIButton) {
    
    if (sender == self.downloadButton) {
      let alertController = UIAlertController(title: LocalData.getLocalizationLabels(forElement: "warningTitle")[languageIndex], message: LocalData.getLocalizationLabels(forElement: "warningMessage_ID")[languageIndex], preferredStyle: .alert)
      let alertAction = UIAlertAction(title: LocalData.getLocalizationLabels(forElement: "warningButton")[languageIndex], style: .default) {
        (alert: UIAlertAction!) -> Void in
          self.removeAnimated()
      }
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
    }
    if (sender == self.cancelButton) {
      self.removeAnimated()
    }

  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
