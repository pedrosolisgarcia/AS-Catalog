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
  
  var shopIds: [String]!

  override func viewDidLoad() -> Void {
    super.viewDidLoad()
    headerLabel.text = ShopIdServiceAPI.shared.hasRegisteredShopId() ?
      "shop-id.label.identified".localized().uppercased() + ShopIdServiceAPI.shared.getShopId()! :
      "shop-id.label.no-identified".localized().uppercased()
    self.confirmButton.setTitle("alert.confirm-button".localized(), for: .normal)
    
    self.shopIdView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    self.shopIdView.layer.shadowColor = UIColor.gray.cgColor
    self.shopIdView.layer.shadowOpacity = 0.75
    
    self.cancelButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    self.cancelButton.layer.shadowColor = UIColor.gray.cgColor
    self.cancelButton.layer.shadowRadius = 0
    self.cancelButton.layer.shadowOpacity = 1

    if !ShopIdServiceAPI.shared.hasRegisteredShopId() {
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
    
    self.getShopIds()
    self.addBlurView(below: shopIdView)
    self.showAnimated()
  }

  override func didReceiveMemoryWarning() -> Void {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func buttonClicked(sender: UIButton) -> Void {
    
    if (sender == self.confirmButton) {
      if self.tryToSaveShopId() {
        self.setLoadingState(to: true)
        self.connectToCollectionView()
      } else {
        self.displayWrongIdAlert()
      }
    }
    if (sender == self.cancelButton) {
      self.removeAnimated()
    }
  }
  
  private func setLoadingState(to enabled: Bool) -> Void {
    self.idFieldView.isHidden = enabled
    self.loadingView.isHidden = !enabled
  }
  
  private func getShopIds() -> Void {
    ShopIdServiceAPI.shared.getShopIds() { (result) in
      switch result {
        case .success(let response):
          DispatchQueue.main.async {
            if response.ids.isEmpty {
              self.showErrorAlert()
              return
            }
            self.confirmButton.isEnabled = true
            print(response)
            self.shopIds = response.ids
            self.shopIds.append("TEST-ID")
          }
        case .failure(let error):
          DispatchQueue.main.async {
            self.displayNoInternetAlert()
          }
          print(error.localizedDescription)
      }
    }
  }
  
  private func connectToCollectionView() -> Void {
    CollectionServiceAPI.shared.getLatestCollection() { (result) in
      switch result {
        case .success(let response):
          DispatchQueue.main.async {
            if response.isEmpty {
              self.showErrorAlert()
              return
            }
            self.showCollectionCheckView(
              CollectionMapper.mapResponseToCollection(response[0])
            )
            self.setLoadingState(to: false)
          }
        case .failure(let error):
          DispatchQueue.main.async {
            self.displayNoInternetAlert()
          }
          print(error.localizedDescription)
      }
    }
  }
  
  private func tryToSaveShopId() -> Bool {
    if (self.shopIds.contains(self.shopIdField.text!.uppercased())) {
      return (nil != ShopIdServiceAPI.shared.saveShopId(shopId: self.shopIdField.text!.uppercased()))
    }
    return false;
  }
  
  private func showCollectionCheckView(_ collection: Collection) -> Void {
    let collectionCheckView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "collectionCheck") as! CollectionCheckViewController
    collectionCheckView.collection = collection
    self.addChild(collectionCheckView)
    collectionCheckView.view.frame = self.view.frame
    self.view.addSubview(collectionCheckView.view)
    collectionCheckView.didMove(toParent: self)
  }
  
  private func displayWrongIdAlert() -> Void {
    let alertController = UIAlertController(
      title: "alert.error.title".localized(),
      message: "alert.wrong-id.message".localized(),
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: "alert.ok-button".localized(),
      style: .default,
      handler: nil
    )
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion:nil)
    self.shopIdField.text = ""
  }
  
  private func displayNoInternetAlert() -> Void {
    let alertController = UIAlertController(
      title: "alert.no-internet.title".localized(),
      message: "alert.no-internet.message".localized(),
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: "alert.ok-button".localized(),
      style: .default
    ) {
      (alert: UIAlertAction!) -> Void in
        self.removeAnimated()
    }
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion:nil)
    self.shopIdField.text = ""
  }
  
  func showErrorAlert() {
    let alertController = UIAlertController(
      title: "alert.error.title".localized(),
      message: "alert.error.message".localized(),
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: "alert.ok-button".localized(),
      style: .default
    ) {
      (alert: UIAlertAction!) -> Void in
        self.removeAnimated()
      }
    alertController.addAction(alertAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  private func shouldDisplayCollectionCheckView() -> Bool {
    return self.shopIds.contains(self.shopIdField.text!.uppercased())
  }
}
