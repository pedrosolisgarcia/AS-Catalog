//
//  ShopIDViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 06/08/18.
//  Copyright © 2018 VILHON Technologies. All rights reserved.
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
    
    private let collectionService: CollectionServiceAPI = CollectionServiceAPI.shared
    private let shopIdService: ShopIdServiceAPI = ShopIdServiceAPI.shared
    
    override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        if !self.shopIdService.hasRegisteredShopId() {
            cancelButton.isEnabled = false
            cancelButton.isHidden = true
        }
        
        self.translateTextKeys()
        self.addBlurView(below: shopIdView)
        self.shopIdView.addViewShadow()
        self.cancelButton.addButtonShadow()
        self.confirmButton.roundCorners(from: .bottom, radius: 10)
        self.headerLabel.roundCorners(from: .top, radius: 10)
        self.showAnimated()
        
        self.getShopIds()
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
        self.shopIdService.getShopIds() { (result) in
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
        self.collectionService.getLatestCollection() { (result) in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        if response.isEmpty {
                            self.showErrorAlert()
                            return
                        }
                        self.showCollectionCheckView(
                            CollectionMapper.shared.mapResponseToCollection(response[0])
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
            return (nil != self.shopIdService.saveShopId(shopId: self.shopIdField.text!.uppercased()))
        }
        return false;
    }
    
    private func showCollectionCheckView(_ collection: Collection) -> Void {
        let collectionCheckView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "collectionCheck") as! CollectionCheckViewController
        collectionCheckView.collection = collection
        collectionCheckView.delegate = self
        self.addChild(collectionCheckView)
        collectionCheckView.view.frame = self.view.frame
        self.view.addSubview(collectionCheckView.view)
        collectionCheckView.didMove(toParent: self)
    }
    
    private func translateTextKeys() -> Void {
        self.headerLabel.text = self.shopIdService.hasRegisteredShopId() ?
        "shop-id.label.identified".localized().uppercased() + self.shopIdService.getShopId()! :
        "shop-id.label.no-identified".localized().uppercased()
        self.confirmButton.setTitle("alert.confirm-button".localized(), for: .normal)
    }
    
    private func displayWrongIdAlert() -> Void {
        self.displaySingleActionAlert(
            title: "alert.error.title",
            message: "alert.wrong-id.message",
            actionTitle: "alert.ok-button",
            action: nil
        )
        self.shopIdField.text = ""
    }
    
    private func displayNoInternetAlert() -> Void {
        self.displaySingleActionAlert(
            title: "alert.no-internet.title",
            message: "alert.no-internet.message",
            actionTitle: "alert.ok-button",
            action: {
                (alert: UIAlertAction!) -> Void in
                if self.shopIdService.hasRegisteredShopId() {
                    self.removeAnimated()
                }
            }
        )
        self.shopIdField.text = ""
    }
    
    private func showErrorAlert() -> Void {
        self.displaySingleActionAlert(
            title: "alert.error.title",
            message: "alert.error.message",
            actionTitle: "alert.ok-button",
            action: nil
        )
    }
    
    private func shouldDisplayCollectionCheckView() -> Bool {
        return self.shopIds.contains(self.shopIdField.text!.uppercased())
    }
}
