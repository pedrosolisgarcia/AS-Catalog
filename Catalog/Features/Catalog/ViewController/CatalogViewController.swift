//
//  CatalogViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 26/09/17.
//  Copyright © 2017 VILHON Technologies. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var catalogView: UIBarButtonItem!
    @IBOutlet weak var carouselView: UIBarButtonItem!
    @IBOutlet weak var selectButton: UIButton!
    
    var clientData: Client!
    
    fileprivate let dressViewModelController = DressViewModelController()
    
    override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        navigationItem.title = "catalog.title".localized().uppercased()
        
        selectButton.setTitle("catalog.button".localized().uppercased(), for: .normal)
        selectButton.isEnabled = false
        selectButton.alpha = 0.25
        
        collectionView?.allowsMultipleSelection = true
        
        dressViewModelController.getDresses()
        self.clientData.collectionId = dressViewModelController.getCollectionId()
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) -> Void {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func viewButtonPressed(_ sender: UIBarButtonItem) -> Void {
        
        let catalogSize = CGSize(width: 246, height: 416)
        let carouselSize = CGSize(width: 515, height: 850)
        let catalogInset = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 7)
        let carouselInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 40)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = sender == catalogView ? catalogSize : carouselSize
        layout.sectionInset = sender == catalogView ? catalogInset : carouselInset
        layout.minimumLineSpacing = sender == catalogView ? 8.0 : 40.0
        layout.minimumInteritemSpacing = sender == catalogView ? 8.0 : 30.0
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        catalogView.image = UIImage(named: sender == catalogView ? "mosaic_sel" : "mosaic")
        carouselView.image = UIImage(named: sender == catalogView ? "carousel" : "carousel_sel")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) -> Void {
        
        if segue.identifier == "selectDresses"{
            
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let destinationController = segue.destination as! SelectionViewController
                
                var dressesNames = [String]()
                
                for index in indexPath {
                    if let viewModel = dressViewModelController.viewModel(at: (index as NSIndexPath).row) {
                        destinationController.selectedDresses.append(viewModel)
                        dressesNames.append(viewModel.name)
                    }
                }
                clientData.dressesNames = (dressesNames as NSArray).componentsJoined(by: ",")
                destinationController.clientData = clientData
            }
        }
    }
}

extension CatalogViewController: UICollectionViewDataSource, CatalogCollectionViewCellZoomable {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dressViewModelController.viewModelsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatalogCollectionViewCell
        
        if let viewModel = dressViewModelController.viewModel(at: (indexPath as NSIndexPath).row) {
            cell.cellDelegate = self
            cell.configure(viewModel)
        }
        
        return cell
    }
    
    func zoomCell(_ sender: UIButton) -> Void {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            let zoomImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageView") as! ImageViewController
            if let viewModel = dressViewModelController.viewModel(at: (indexPath as NSIndexPath).row) {
                zoomImageView.dress = viewModel.image
                self.addChild(zoomImageView)
                zoomImageView.view.frame = self.view.frame
                self.view.addSubview(zoomImageView.view)
                zoomImageView.didMove(toParent: self)
            }
        }
    }
    
    private func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath: IndexPath = collectionView.indexPathForItem(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
}

extension CatalogViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void {
        selectButton.isEnabled = true
        selectButton.alpha = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) -> Void {
        if let indexPath = collectionView.indexPathsForSelectedItems {
            if indexPath.count <= 0 {
                selectButton.isEnabled = false
                selectButton.alpha = 0.25
            }
        }
    }
}
