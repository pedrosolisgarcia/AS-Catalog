//
//  CatalogViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 26/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CatalogCollectionViewCellDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var catalogView: UIBarButtonItem!
    @IBOutlet var carouselView: UIBarButtonItem!
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var selectButton: UIButton!
    
    var selectLang: [String] = ["","CONTINUE WITH SELECTION","CONTINUAR CON LA SELECCIÓN"]
    var titleLang: [String] = ["KATALOG","CATALOG","CATÁLOGO"]
    
    var dresses: [Dress] = [Dress(name: "Adelia", imgName: "adelia", isSelected: false),
                            Dress(name: "Adora", imgName: "Adora", isSelected: false),
                            Dress(name: "Adora z Trenem", imgName: "adora z trenem", isSelected: false),
                            Dress(name: "Alicia", imgName: "alicia", isSelected: false),
                            Dress(name: "Aurora", imgName: "aurora", isSelected: false),
                            Dress(name: "Aurora z Aplikacją", imgName: "aurora1", isSelected: false),
                            Dress(name: "Bonita", imgName: "bonita", isSelected: false),
                            Dress(name: "Bonita ze Spódnicą", imgName: "bonita3", isSelected: false),
                            Dress(name: "Cassandra", imgName: "cassandra", isSelected: false),
                            Dress(name: "Diamantina", imgName: "diamantina", isSelected: false),
                            Dress(name: "Dulce", imgName: "dulce", isSelected: false),
                            Dress(name: "Elodia", imgName: "elodia", isSelected: false),
                            Dress(name: "Elsa", imgName: "elsa", isSelected: false),
                            Dress(name: "Felicia", imgName: "felicia", isSelected: false),
                            Dress(name: "Ivette", imgName: "ivette", isSelected: false),
                            Dress(name: "Luna", imgName: "luna", isSelected: false),
                            Dress(name: "Micaela", imgName: "Micaela", isSelected: false),
                            Dress(name: "Monica", imgName: "monica", isSelected: false),
                            Dress(name: "Monica z Peleryną",imgName:"Monica Aplication",isSelected:false),
                            Dress(name: "Morena", imgName: "morena", isSelected: false),
                            Dress(name: "Ofelia", imgName: "ofelia", isSelected: false),
                            Dress(name: "Olimpia", imgName: "olimpia", isSelected: false),
                            Dress(name: "Paloma", imgName: "paloma", isSelected: false),
                            Dress(name: "Paola", imgName: "paola", isSelected: false),
                            Dress(name: "Rebeca", imgName: "rebeca", isSelected: false),
                            Dress(name: "Samantha", imgName: "Samantha", isSelected: false),
                            Dress(name: "Samantha z Trenem", imgName: "Samantha 1", isSelected: false),
                            Dress(name: "Susana", imgName: "susana", isSelected: false)]
    
    var zoomDress: Dress!
    var provCart: Cart!
    var languageIndex: Int!
    
    let catalogSize = CGSize(width: 246, height: 420)
    let carouselSize = CGSize(width: 515, height: 850)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        if languageIndex != 0 {
            
            selectButton.setTitle(selectLang[languageIndex], for: .normal)
        }
        navigationItem.title = titleLang[languageIndex]
        collectionView?.allowsMultipleSelection = true
        selectButton.isEnabled = false
        selectButton.alpha = 0.25
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatalogCollectionViewCell
        cell.cellDelegate = self
        
        let dress = dresses[indexPath.row]
        
        // Configure the cell
        cell.dressLabel.font = UIFont(name: "TrajanPro-Regular", size: 22)
        cell.dressLabel.text = dress.name
        cell.dressImageView.image = UIImage(named: dress.imgName)
        
        // In case the cell is selected
        cell.selectedFlag.image = dress.isSelected ? UIImage(named: "tick") : nil
        cell.dressLabel.backgroundColor = dress.isSelected ? UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 0.75) : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        
        
        return cell
    }
    
    func didPressZoomButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            let zoomImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageView") as! ImageViewController
            zoomImageView.dress = dresses[indexPath.row].imgName
            self.addChildViewController(zoomImageView)
            zoomImageView.view.frame = self.view.frame
            self.view.addSubview(zoomImageView.view)
            zoomImageView.didMove(toParentViewController: self)
        }
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath: IndexPath = collectionView.indexPathForItem(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dresses[indexPath.row].isSelected = true
        selectButton.isEnabled = true
        selectButton.alpha = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        dresses[indexPath.row].isSelected = false
        if let indexPath = collectionView.indexPathsForSelectedItems {
            if indexPath.count <= 0 {
                selectButton.isEnabled = false
                selectButton.alpha = 0.25
            }
        }
    }
    
    @IBAction func viewButtonPressed(_ sender: UIBarButtonItem) {
        
        if sender == catalogView {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = catalogSize
            layout.sectionInset = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 7)
            layout.minimumLineSpacing = 8.0
            layout.minimumInteritemSpacing = 8.0
            //cell.dressLabel.font = dressLabel.font.fontWithSize(20)
            collectionView.setCollectionViewLayout(layout, animated: true)
            catalogView.image = UIImage(named: "mosaic_sel")
            carouselView.image = UIImage(named: "carousel")
        }
        if sender == carouselView {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = carouselSize
            layout.sectionInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 40)
            layout.minimumLineSpacing = 40.0
            layout.minimumInteritemSpacing = 30.0
            //cell.dressLabel.font = dressLabel.font.fontWithSize(25)
            collectionView.setCollectionViewLayout(layout, animated: true)
            catalogView.image = UIImage(named: "mosaic")
            carouselView.image = UIImage(named: "carousel_sel")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectDresses"{
            if let indexPath = collectionView.indexPathsForSelectedItems {
                
                let destinationController = segue.destination as! SelectionViewController
                
                destinationController.languageIndex = languageIndex
                destinationController.provCart = provCart
                
                for index in indexPath {
                    destinationController.dresses.append(dresses[index.row])
                    destinationController.dressNames.append(dresses[index.row].name)
                }
            }
        }
    }
}
