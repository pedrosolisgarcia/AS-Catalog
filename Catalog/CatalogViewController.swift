//
//  CatalogViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 26/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class CatalogViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CatalogCollectionViewCellDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var catalogView: UIBarButtonItem!
    @IBOutlet var carouselView: UIBarButtonItem!
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var selectButton: UIButton!
    
    @IBOutlet var saveToDatabaseButton: UIBarButtonItem!
    
    var selectLang: [String] = ["","CONTINUE WITH SELECTION","CONTINUAR CON LA SELECCIÓN"]
    var titleLang: [String] = ["KATALOG","CATALOG","CATÁLOGO"]
    
    //var fetchResultsController: NSFetchedResultsController<DressMO>!
    
    var dressesMO: [DressMO] = []
    var dressMO: DressMO!
    
    var dresses: [Dress] = [Dress(name: "Adelia", image: "adelia"),
                                Dress(name: "Adora", image: "Adora"),
                                Dress(name: "Adora z Trenem", image: "adora z trenem"),
                                Dress(name: "Alicia", image: "alicia"),
                                Dress(name: "Aurora", image: "aurora"),
                                Dress(name: "Aurora z Aplikacją", image: "aurora1"),
                                Dress(name: "Bonita", image: "bonita"),
                                Dress(name: "Bonita ze Spódnicą", image: "bonita3"),
                                Dress(name: "Cassandra", image: "cassandra"),
                                Dress(name: "Diamantina", image: "diamantina"),
                                Dress(name: "Dulce", image: "dulce"),
                                Dress(name: "Elodia", image: "elodia"),
                                Dress(name: "Elsa", image: "elsa"),
                                Dress(name: "Felicia", image: "felicia"),
                                Dress(name: "Ivette", image: "ivette"),
                                Dress(name: "Luna", image: "luna"),
                                Dress(name: "Micaela", image: "Micaela"),
                                Dress(name: "Monica", image: "monica"),
                                Dress(name: "Monica z Peleryną",image:"Monica Aplication"),
                                Dress(name: "Morena", image: "morena"),
                                Dress(name: "Ofelia", image: "ofelia"),
                                Dress(name: "Olimpia", image: "olimpia"),
                                Dress(name: "Paloma", image: "paloma"),
                                Dress(name: "Paola", image: "paola"),
                                Dress(name: "Rebeca", image: "rebeca"),
                                Dress(name: "Samantha", image: "Samantha"),
                                Dress(name: "Samantha z Trenem", image: "Samantha 1"),
                                Dress(name: "Susana", image: "susana")]
    
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
        cell.dressLabel.font = UIFont(name : "TrajanPro-Regular", size: 22)
        cell.dressLabel.text = dress.name
        cell.dressImageView.image = UIImage(named: dress.image)
        //cell.dressImageView.image = UIImage(data: self.dresses[indexPath.row].image as! Data)
        
        // In case the cell is selected
        /*cell.selectedFlag.image = dress.isSelected ? UIImage(named: "tick") : nil
         cell.dressLabel.backgroundColor = dress.isSelected ? UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 0.75) : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)*/
        
        
        return cell
    }
    
    func didPressZoomButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            let zoomImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageView") as! ImageViewController
            //zoomImageView.dressImageView.image = UIImage(data: self.dresses[indexPath.row].image as! Data)
            zoomImageView.dressImageView.image = UIImage(named: dresses[indexPath.row].image)
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
    
    @IBAction func saveCatalogToDatabase(_ sender: UIButton) {
        
        for dress in dresses {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                dressMO = DressMO(context: appDelegate.persistentContainer.viewContext)
                dressMO.name = dress.name
                
                let imageData = UIImagePNGRepresentation(UIImage(named: dress.image)!)
                dressMO.image = NSData(data: imageData!)
                appDelegate.saveContext()
                
                print(dressMO)
            }
        }
    }
    
    @IBAction func deleteCatalogFromDatabase(_ sender: UIButton) {
        
        for dress in dressesMO {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                context.delete(dress)
                appDelegate.saveContext()
                
                print(dressesMO)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectDresses"{
            if let indexPath = collectionView.indexPathsForSelectedItems {
                
                let destinationController = segue.destination as! SelectionViewController
                
                destinationController.languageIndex = languageIndex
                destinationController.provCart = provCart
                
                for index in indexPath {
                    destinationController.dresses.append(dressesMO[index.row])
                    destinationController.dressNames.append(dressesMO[index.row].name!)
                }
            }
        }
    }
}
