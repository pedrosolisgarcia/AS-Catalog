//
//  HomeViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 29/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITextFieldDelegate {
    
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
    
    var weddingDatePicker: UIPicker!
    
    var beforeLang: [String] = ["Przed obejrzeniem katalogu, proszę o identyfikację:","Before watching the catalog, please identify yourself:","Antes de ver el catalogo, por favor identifícate:"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var lastnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var phoneLang = ["Telefon:","Telefon:","Teléfono:"]
    var hometownLang = ["Miasto:","City:","Ciudad:"]
    var weddingDateLang = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    var numDay = [01...31]
    var monthsLang = [["styczeń", "luty", "marzec", "kwiecień", "maj", "czerwiec", "lipiec", "sierpień", "wrzesień", "październik", "listopad", "grudzień"], ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]]
    var numMonths = [01...12]
    var numYear = [2017...2030]
    var numberOfRows = [31,12,13]
    var doneLang: [String] = ["Gotowy","Done","Hecho"]
    var cancelLang: [String] = ["Anuluj","Cancel","Cancelar"]
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.pickWeddingDate(self.weddingDateField)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return numberOfRows[component]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return numDay[row]
        } else if component == 1 {
            return monthsLang[languageIndex][row]
        } else {
            return numYear[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let day = numDay[pickerView.selectedRow(inComponent: 0)]
        
        let month = numMonths[pickerView.selectedRow(inComponent: 1)]
        
        let year = numYear[pickerView.selectedRow(inComponent: 2)]
        
        pickerTextField.text = day + "/" + month + "/" + year
    }
    
    /*func pickWeddingDate(_ textField : UITextField){
        
            self.weddingDatePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.weddingDatePicker.backgroundColor = UIColor.white
            self.weddingDatePicker.accessibilityLanguage = "en"
            self.weddingDatePicker.datePickerMode = UIDatePickerMode.date
            textField.inputView = self.weddingDatePicker
            
            // ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
            toolBar.sizeToFit()
            
            // Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: doneLang[languageIndex], style: .plain, target: self, action: #selector(HomeViewController.doneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: cancelLang[languageIndex], style: .plain, target: self, action: #selector(HomeViewController.cancelClick))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolBar
    }
    
    func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        weddingDateField.text = dateFormatter1.string(from: weddingDatePicker.date)
        weddingDateField.resignFirstResponder()
    }
    func cancelClick() {
        weddingDateField.resignFirstResponder()
    }*/
    
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
