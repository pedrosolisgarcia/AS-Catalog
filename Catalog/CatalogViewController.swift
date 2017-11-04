//
//  CatalogViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 26/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CatalogCollectionViewCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var catalogView: UIBarButtonItem!
    @IBOutlet weak var carouselView: UIBarButtonItem!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    var selectLang: [String] = ["","CONTINUE WITH SELECTION","CONTINUAR CON LA SELECCIÓN"]
    var titleLang: [String] = ["KATALOG","CATALOG","CATÁLOGO"]
    
    var dresses = [Dress]()
    
    //weak var zoomDress: Dress!
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
        dresses.removeAll()
        //collectionView = nil
        dresses = [Dress(name: "Adelia", imgName: "adelia"),
                   Dress(name: "Adora", imgName: "Adora"),
                   Dress(name: "Adora z Trenem", imgName: "adora z trenem"),
                   Dress(name: "Alicia", imgName: "alicia"),
                   Dress(name: "Aurora", imgName: "aurora"),
                   Dress(name: "Aurora z Aplikacją", imgName: "aurora1"),
                   Dress(name: "Bonita", imgName: "bonita"),
                   Dress(name: "Bonita ze Spódnicą", imgName: "bonita3"),
                   Dress(name: "Cassandra", imgName: "cassandra"),
                   Dress(name: "Diamantina", imgName: "diamantina"),
                   Dress(name: "Dulce", imgName: "dulce"),
                   Dress(name: "Elodia", imgName: "elodia"),
                   Dress(name: "Elsa", imgName: "elsa"),
                   Dress(name: "Felicia", imgName: "felicia"),
                   Dress(name: "Ivette", imgName: "ivette"),
                   Dress(name: "Luna", imgName: "luna"),
                   Dress(name: "Micaela", imgName: "Micaela"),
                   Dress(name: "Monica", imgName: "monica"),
                   Dress(name: "Monica z Peleryną",imgName: "Monica Aplication"),
                   Dress(name: "Morena", imgName: "morena"),
                   Dress(name: "Ofelia", imgName: "ofelia"),
                   Dress(name: "Olimpia", imgName: "olimpia"),
                   Dress(name: "Paloma", imgName: "paloma"),
                   Dress(name: "Paola", imgName: "paola"),
                   Dress(name: "Rebeca", imgName: "rebeca"),
                   Dress(name: "Samantha", imgName: "Samantha"),
                   Dress(name: "Samantha z Trenem", imgName: "Samantha 1"),
                   Dress(name: "Susana", imgName: "susana")]
        
        navigationItem.title = titleLang[languageIndex]
        collectionView?.allowsMultipleSelection = true
        selectButton.isEnabled = false
        selectButton.alpha = 0.25
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        /*cell?.selectedFlag.image = dress.isSelected ? UIImage(named: "tick") : nil
        cell?.dressLabel.backgroundColor = dress.isSelected ? UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 0.75) : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)*/
        
        
        return cell
    }
    
    func didPressZoomButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            weak var zoomImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageView") as? ImageViewController
            zoomImageView?.dress = dresses[indexPath.row].imgName + "_full"
            self.addChildViewController(zoomImageView!)
            zoomImageView?.view.frame = self.view.frame
            self.view.addSubview(zoomImageView!.view)
            zoomImageView?.didMove(toParentViewController: self)
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
        
        //dresses[indexPath.row].isSelected = true
        selectButton.isEnabled = true
        selectButton.alpha = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        //dresses[indexPath.row].isSelected = false
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
                self.dismiss(animated: false)
            }
        }
    }
}
