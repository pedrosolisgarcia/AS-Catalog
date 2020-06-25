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
  @IBOutlet weak var idFieldView: UIView!
  @IBOutlet weak var loadingView: UIView!
  
  var languageIndex: Int!

  override func viewDidLoad() -> Void {
    super.viewDidLoad()
    headerLabel.text = ShopIdManager.isThereAnyShopIdRegisteredAlready() ?
      LocalData.getLocalizationLabels(forElement: "headerLabel_ID_Identified")[languageIndex] + ShopIdManager.retrieveIPadShopId()! :
      LocalData.getLocalizationLabels(forElement: "headerLabel_ID")[languageIndex]
    cancelButton.setTitle(LocalData.getLocalizationLabels(forElement: "cancelButton")[languageIndex], for: .normal)
    confirmButton.setTitle(LocalData.getLocalizationLabels(forElement: "confirmButton")[languageIndex], for: .normal)
    
    self.shopIdView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    self.shopIdView.layer.shadowColor = UIColor.gray.cgColor
    self.shopIdView.layer.shadowOpacity = 0.75
    
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
    self.showAnimated()
  }
  
  func addBlurView() -> Void {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    self.view.insertSubview(blurEffectView, belowSubview: shopIdView)
  }
  

  override func didReceiveMemoryWarning() -> Void {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func buttonClicked(sender: UIButton) -> Void {
    
    if (sender == self.confirmButton) {
      if self.tryToSaveShopId() {
        if self.shouldDisplayCollectionCheckView() {
          self.idFieldView.isHidden = true
          self.loadingView.isHidden = false
          CollectionServiceAPI.shared.fetchLatestCollection() { (result) in
            switch result {
              case .success(let response):
                DispatchQueue.main.async {
                  self.showCollectionCheckView(
                    CollectionMapper.mapResponseToCollection(response[0])
                  )
                  self.idFieldView.isHidden = false
                  self.loadingView.isHidden = true
                }
              case .failure(let error):
                DispatchQueue.main.async {
                  self.displayWrongIdAlert()
                }
                print(error.localizedDescription)
            }
          }
        } else {
          self.removeAnimated()
        }
      } else {
        self.displayWrongIdAlert()
      }
    }
    if (sender == self.cancelButton) {
      self.removeAnimated()
    }

  }
  
  private func tryToSaveShopId() -> Bool {
    if (ShopIdManager.validShopIds().contains(self.shopIdField.text!.uppercased())) {
      return (nil != ShopIdManager.saveShopIdInIPad(shopId: self.shopIdField.text!.uppercased()))
    }
    return false;
  }
  
  private func showCollectionCheckView(_ collection: Collection) -> Void {
    let collectionCheckView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "collectionCheck") as! CollectionCheckViewController
    collectionCheckView.languageIndex = self.languageIndex
    collectionCheckView.collection = collection
    self.addChild(collectionCheckView)
    collectionCheckView.view.frame = self.view.frame
    self.view.addSubview(collectionCheckView.view)
    collectionCheckView.didMove(toParent: self)
  }
  
  private func displayWrongIdAlert() -> Void {
    let alertController = UIAlertController(title: LocalData.getLocalizationLabels(forElement: "warningTitle")[languageIndex], message: LocalData.getLocalizationLabels(forElement: "warningMessage_ID")[languageIndex], preferredStyle: .alert)
    let alertAction = UIAlertAction(title: LocalData.getLocalizationLabels(forElement: "warningButton")[languageIndex], style: .default, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion:nil)
    self.shopIdField.text = ""
  }
  
  private func shouldDisplayCollectionCheckView() -> Bool {
    return ShopIdManager.collectionIds().contains(self.shopIdField.text!.uppercased())
  }
}
