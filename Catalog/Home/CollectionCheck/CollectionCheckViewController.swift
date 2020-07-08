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

  weak var delegate: ShopIDViewController!

  var collection: Collection!
  var dressesImages: [Data]!
  
  private let collectionService: CollectionServiceAPI = CollectionServiceAPI.shared
  private let shopIdService: ShopIdServiceAPI = ShopIdServiceAPI.shared

  override func viewDidLoad() -> Void {
    super.viewDidLoad()

    
    if !self.shopIdService.hasRegisteredShopId() {
      cancelButton.isEnabled = false
      cancelButton.isHidden = true
    }
    
    self.translateTextKeys()
    self.collectionCheckView.addViewShadow()
    self.cancelButton.addButtonShadow()
    self.downloadButton.roundCorners(from: .bottom, radius: 10)
    self.collectionCheckLabel.roundCorners(from: .top, radius: 10)
    self.showAnimated()
    
    print(collection!)
  }
  
  @IBAction func removeAnimate(sender: UIButton) -> Void {
    
    if (sender == self.downloadButton) {
      downloadImage()
    }
    if (sender == self.cancelButton) {
      self.delegate.removeAnimated()
      self.removeAnimated()
    }
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  private func downloadImage() -> Void {
    let dispatchGroup = DispatchGroup()
    self.downloadView.isHidden = true
    self.loadingView.isHidden = false
    for (index, dress) in collection.dresses.enumerated() {
      dispatchGroup.enter()

      let url = URL(string: dress.imageUrl)!
      collectionService.getImageData(from: url) { (result) in
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
  
  private func translateTextKeys() -> Void {
    collectionCheckLabel.text = "collection-check.title".localized().uppercased()
    textTop.text = "collection-check.text-top".localized()
    collectionLabel.text = collection.name
    textBottom.text = "collection-check.text-bottom".localized()
    downloadButton.setTitle("collection-check.button".localized(), for: .normal)
  }
  
  private func showSuccessAlert() -> Void {
    self.displaySingleActionAlert(
      title: "alert.collection-downloaded.title",
      message: "alert.collection-downloaded.message",
      actionTitle: "alert.ok-button",
      action: {
        (alert: UIAlertAction!) -> Void in
          self.delegate.removeAnimated()
          self.removeAnimated()
      }
    )
  }
  
  private func showErrorAlert() -> Void {
    self.displaySingleActionAlert(
      title: "alert.error.title",
      message: "alert.error.message",
      actionTitle: "alert.ok-button",
      action: {
        (alert: UIAlertAction!) -> Void in
          self.removeAnimated()
      }
    )
  }
}
