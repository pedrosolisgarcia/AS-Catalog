//
//  HomeViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 29/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var polishButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    
    @IBOutlet weak var beforeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var hometownField: UITextField!
    @IBOutlet weak var weddingDateLabel: UILabel!
    @IBOutlet weak var weddingDateField: UITextField!
    @IBOutlet weak var createProfileButton: UIButton!
    
    @IBOutlet weak var lowSeparator: UIView!
    @IBOutlet weak var lowText: UILabel!
    @IBOutlet weak var catalogButton: UIButton!
    
    var beforeLang: [String] = ["Przed obejrzeniem katalogu, proszę o identyfikację:","Before watching the catalog, please identify yourself:","Antes de ver el catalogo, por favor identifícate:"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var lastnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var phoneLang: [String] = ["Telefon:","Telefon:","Teléfono:"]
    var hometownLang: [String] = ["Miasto:","City:","Ciudad:"]
    var weddingDateLang: [String] = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    var createProfileLang: [String] = ["UTWÓRZ PROFIL","CREATE PROFILE","CREAR PERFIL"]
    var warningMessageLang: [[String]] = [["Błąd","Wszystkie pola muszą być wypełnione, aby zobaczyć katalog.","Dobra"],["Error","All the fields must be filled to see the catalog.","Ok"],["Error","Todos los campos han de ser rellenados para poder ver el catálogo.","Vale"]]
    var lowTextLang: [String] = ["Możesz zobaczyć katalog.","Now you can watch the catalog.","Ya puedes ver el catálogo."]
    var catalogLang: [String] = ["OBEJRZYJ KATALOG","WATCH THE CATALOG","VISITA EL CATÁLOGO"]
    var languageIndex = 0
    
    var fields: [Bool] = [false,false,false,false,false]
    //var cart: cart = cart(name: "", lastname: "", email: "", phone: "", hometown: "")
    var provCart: Cart = Cart(name: "", lastname: "", email: "", phone: "", city: "", weddingDate: "", dresses: [""])
    
    @IBAction func selectLanguage(sender: UIButton) {
        
        if sender == polishButton  {
            languageIndex = 0
            polishButton.isHighlighted = true
            englishButton.isHighlighted = false
            spanishButton.isHighlighted = false
        }
        if sender == englishButton {
            languageIndex = 1
            polishButton.isHighlighted = false
            englishButton.isHighlighted = true
            spanishButton.isHighlighted = false
        }
        if sender == spanishButton {
            languageIndex = 2
            polishButton.isHighlighted = false
            englishButton.isHighlighted = false
            spanishButton.isHighlighted = true
        }
        
        beforeLabel.text = beforeLang[languageIndex]
        nameLabel.text = nameLang[languageIndex]
        lastnameLabel.text = lastnameLang[languageIndex]
        phoneLabel.text = phoneLang[languageIndex]
        hometownLabel.text = hometownLang[languageIndex]
        weddingDateLabel.text = weddingDateLang[languageIndex]
        createProfileButton.setTitle(createProfileLang[languageIndex], for: .normal)
        lowText.text = lowTextLang[languageIndex]
        catalogButton.setTitle(catalogLang[languageIndex], for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
        lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        catalogButton.isEnabled = false
        catalogButton.alpha = 0
        
        hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func createProfile(sender: UIButton) {
        if nameField.text == "" || lastnameField.text == "" || emailField.text == "" || hometownField.text == "" || weddingDateField.text == "" {
            let alertController = UIAlertController(title: warningMessageLang[languageIndex][0], message: warningMessageLang[languageIndex][1], preferredStyle: .alert)
            let alertAction = UIAlertAction(title: warningMessageLang[languageIndex][2], style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
        } else {
            provCart.name = nameField.text!
            provCart.lastname = lastnameField.text!
            provCart.email = emailField.text!
            provCart.phone = phoneField.text!
            provCart.city = hometownField.text!
            provCart.weddingDate = weddingDateField.text!
            
            lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            catalogButton.isEnabled = true
            catalogButton.alpha = 1
        }
        dismissKeyboard()
    }
    
    //Prepare data from the selected exercise to be shown in the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showCatalog"{
            
            let destinationController = segue.destination as! CatalogViewController
            destinationController.languageIndex = languageIndex
            destinationController.provCart = provCart
        }
    }
    
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() { view.endEditing(true) }
}
