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
  
  var languageIndex: Int!
  var collection: Collection!
  var dressesImages: [Data]!

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionCheckLabel.text = LocalData.getLocalizationLabels(forElement: "collectionCheckLabel")[languageIndex]
    cancelButton.setTitle(LocalData.getLocalizationLabels(forElement: "cancelButton")[languageIndex], for: .normal)
    textTop.text = LocalData.getLocalizationLabels(forElement: "collectionCheckTextTop")[languageIndex]
    collectionLabel.text = collection.name
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

        let alertController = UIAlertController(title: "Success", message: "Collection succesfully downloaded", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: LocalData.getLocalizationLabels(forElement: "warningButton")[self.languageIndex], style: .default) {
          (alert: UIAlertAction!) -> Void in
            self.removeAnimated()
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
      } catch {
          print("Couldn't write file")
      }
    })
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
