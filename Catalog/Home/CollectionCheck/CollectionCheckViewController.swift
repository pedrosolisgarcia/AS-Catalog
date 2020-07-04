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
  @IBOutlet weak var downloadView: UIView!
  @IBOutlet weak var loadingView: UIView!

  var collection: Collection!
  var dressesImages: [Data]!

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionCheckLabel.text = "collection-check.title".localized().uppercased()
    textTop.text = "collection-check.text-top".localized()
    collectionLabel.text = collection.name
    textBottom.text = "collection-check.text-bottom".localized()
    downloadButton.setTitle("collection-check.button".localized(), for: .normal)
    
    self.cancelButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    self.cancelButton.layer.shadowColor = UIColor.gray.cgColor
    self.cancelButton.layer.shadowRadius = 0
    self.cancelButton.layer.shadowOpacity = 1
    
    if ShopIdServiceAPI.shared.hasRegisteredShopId() {
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
    
    print(collection!)

    self.showAnimated()
  }
  
  @IBAction func removeAnimate(sender: UIButton) {
    
    if (sender == self.downloadButton) {
      downloadImage()
    }
    if (sender == self.cancelButton) {
      self.removeAnimated()
    }

  }
  
  func downloadImage() {
    let dispatchGroup = DispatchGroup()
    self.downloadView.isHidden = true
    self.loadingView.isHidden = false
    for (index, dress) in collection.dresses.enumerated() {
      dispatchGroup.enter()

      let url = URL(string: dress.imageUrl)!
      CollectionServiceAPI.shared.getImageData(from: url) { (result) in
        switch result {
          case .success(let response):
            self.collection.dresses[index].imageData = response
            print("Dress \(dress.name): ", self.collection.dresses[index])
            dispatchGroup.leave()
          case .failure(let error):
            print(error.localizedDescription)
            DispatchQueue.main.async {
              self.showErrorAlert()
            }
        }
      }
  }
    dispatchGroup.notify(queue: DispatchQueue.main, execute: {
      let fullPath = self.getDocumentsDirectory().appendingPathComponent("DRESS_COLLECTION")
      print(fullPath)

      do {
        let jsonData = try JSONEncoder().encode(self.collection!)
        let encodedCollection = try NSKeyedArchiver.archivedData(withRootObject: jsonData, requiringSecureCoding: false)
        try encodedCollection.write(to: fullPath)
        print("Here the encoded object", encodedCollection as Any)
        self.showSuccessAlert()
      } catch {
          print("Couldn't write file")
          self.showErrorAlert()
      }
    })
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func showSuccessAlert() {
    let alertController = UIAlertController(
      title: "alert.collection-downloaded.title".localized(),
      message: "alert.collection-downloaded.message".localized(),
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

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
