//
//  SelectionViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 08/10/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class SelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var weddingDateLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var backHomeScreen: UIBarButtonItem!
    
    var dresses = [Dress]()
    var dressNames = [String]()
    var cart: CartMO!
    var provCart: Cart!
    var languageIndex: Int!
    
    var titleLang: [String] = ["WYBRANE MODELE","SELECTED MODELS","MODELOS SELECCIONADOS"]
    var homeLang: [String] = ["POWRÓT","HOME","INICIO"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var lastnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var hometownLang: [String] = ["Miasto:","City:","Ciudad:"]
    var weddingDateLang: [String] = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    var confirmLang: [String] = ["","CONFIRM SELECTION","CONFIRMAR SELECCIÓN"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provCart.dresses = dressNames
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        nameLabel.text = nameLang[languageIndex] + " " + provCart.name
        lastnameLabel.text = lastnameLang[languageIndex] + " " + provCart.lastname
        hometownLabel.text = hometownLang[languageIndex] + " " + provCart.city
        weddingDateLabel.text = weddingDateLang[languageIndex] + " " + provCart.weddingDate
        if languageIndex != 0 {
            
            saveButton.setTitle(confirmLang[languageIndex], for: .normal)
        }
        navigationItem.title = titleLang[languageIndex]
        backHomeScreen.title = homeLang[languageIndex]
        backHomeScreen.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.cleanExpiredDiskCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! SelectionTableViewCell
        tableView.separatorColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
        let dress = dresses[indexPath.row]
        
        // Configure the cell
        cell.dressLabel.font = UIFont(name: "TrajanPro-Regular", size: 32)
        cell.dressLabel.text = dress.name
        cell.dressImageView.image = UIImage(named: dress.imgName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectedDressView") as! SelectedDressViewController
        popImageView.dressImage = dresses[indexPath.row].imgName
        self.addChildViewController(popImageView)
        popImageView.view.frame = self.view.frame
        self.view.addSubview(popImageView.view)
        popImageView.didMove(toParentViewController: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func saveSelectionToCart(_ sender: UIButton) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            cart = CartMO(context: appDelegate.persistentContainer.viewContext)
            cart.name = provCart.name
            cart.lastname = provCart.lastname
            cart.email = provCart.email
            cart.phone = provCart.phone
            cart.city = provCart.city
            cart.weddingDate = provCart.weddingDate
            cart.dresses = provCart.dresses as NSArray?
            
            appDelegate.saveContext()
            
            saveButton.isEnabled = false
            saveButton.alpha = 0.25
            backHomeScreen.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            backHomeScreen.isEnabled = true
        }
    }
}
