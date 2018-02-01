//
//  HomeViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 29/09/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var recordsButton: UIButton!
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
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var regionField: UITextField!
    @IBOutlet weak var weddingDateLabel: UILabel!
    @IBOutlet weak var weddingDateField: UITextField!
    @IBOutlet weak var createProfileButton: UIButton!
    
    @IBOutlet weak var lowSeparator: UIView!
    @IBOutlet weak var lowText: UILabel!
    @IBOutlet weak var catalogButton: UIButton!
    
    var regionPicker = UIPickerView()
    var weddingDatePicker = UIPickerView()
    
    var beforeLang: [String] = ["Przed obejrzeniem katalogu, proszę o identyfikację:","Before watching the catalog, please identify yourself:","Antes de ver el catalogo, por favor identifícate:"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var lastnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var phoneLang = ["Telefon:","Telefon:","Teléfono:"]
    var regionLang = ["Województwo:","Region:","Región:"]
    var weddingDateLang = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    var numDay = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    var monthsLang = [["styczeń", "luty", "marzec", "kwiecień", "maj", "czerwiec", "lipiec", "sierpień", "wrzesień", "październik", "listopad", "grudzień"], ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]]
    var otherCountry = ["Nie jestem z Polski..", "I am not from Poland..", "No soy de Polonia.."]
    var regionNames = ["dolnośląskie", "kujawsko-pomorskie", "lubelskie", "lubuskie", "łódzkie", "małopolskie", "mazowieckie", "opolskie", "podkarpackie", "podlaskie", "pomorskie", "śląskie", "świętokrzyskie", "warmińsko-mazurskie", "wielkopolskie", "zachodniopomorskie"]
    var numMonths = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    var numYear = [2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030]
    var numberOfRows = [31,12,13]
    var doneLang: [String] = ["Gotowy","Done","Hecho"]
    var cancelLang: [String] = ["Anuluj","Cancel","Cancelar"]
    var createProfileLang: [String] = ["UTWÓRZ PROFIL","CREATE PROFILE","CREAR PERFIL"]
    var warningMessageLang: [[String]] = [["Błąd","Wszystkie pola muszą być wypełnione, aby zobaczyć katalog.","Dobra"],["Error","All the fields must be filled to see the catalog.","Ok"],["Error","Todos los campos han de ser rellenados para poder ver el catálogo.","Vale"]]
    var lowTextLang: [String] = ["Możesz zobaczyć katalog.","Now you can watch the catalog.","Ya puedes ver el catálogo."]
    var catalogLang: [String] = ["OBEJRZYJ KATALOG","WATCH THE CATALOG","VISITA EL CATÁLOGO"]
    var languageIndex: Int!
    static var selectedCountry = ""
    
    
    
    var fields: [Bool] = [false,false,false,false,false]
    var provCart: Cart!
    var monthCal: String!
    var year: String!
    var month = [String]()
    var fullMonth: String!
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue){
        if segue.identifier == "unwindToHomeScreen" {
            resetHomeSettings()
            resetHomeFields()
        }
        if segue.identifier == "unwindToPolishRegion" {
            
            self.pickregion(self.regionField)
        }
    }
    
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
        applyLanguage()
    }
    
    func applyLanguage() {
        
        beforeLabel.text = beforeLang[languageIndex]
        nameLabel.text = nameLang[languageIndex]
        lastnameLabel.text = lastnameLang[languageIndex]
        phoneLabel.text = phoneLang[languageIndex]
        regionLabel.text = regionLang[languageIndex]
        weddingDateLabel.text = weddingDateLang[languageIndex]
        createProfileButton.setTitle(createProfileLang[languageIndex], for: .normal)
        lowText.text = lowTextLang[languageIndex]
        catalogButton.setTitle(catalogLang[languageIndex], for: .normal)
        weddingDatePicker.reloadComponent(1)
    }
    
    @IBAction func showPassword(sender: UIButton) {
        
        let popPasswordView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PasswordView") as! PasswordViewController
        self.addChildViewController(popPasswordView)
        popPasswordView.view.frame = self.view.frame
        self.view.addSubview(popPasswordView.view)
        popPasswordView.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionPicker.delegate = self
        weddingDatePicker.delegate = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    
        resetHomeSettings()
        hideKeyboard()
    }
    
    func resetHomeSettings() {
        languageIndex = 0
        applyLanguage()
        lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        catalogButton.isEnabled = false
        catalogButton.alpha = 0
    }
    func resetHomeFields() {
        provCart = nil
        nameField.text = nil
        lastnameField.text = nil
        emailField.text = nil
        phoneField.text = nil
        regionField.text = nil
        weddingDateField.text = nil
        month.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == regionField {
            self.pickregion(self.regionField)
        }
        if textField == weddingDateField {
            self.pickWeddingDate(self.weddingDateField)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var numComponents = 0
        if pickerView == regionPicker {
            numComponents = 1
        }
        if pickerView == weddingDatePicker {
            numComponents = 3
        }
        return numComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numRows = 0
        if pickerView == regionPicker {
            numRows = regionNames.count + 1
        }
        if pickerView == weddingDatePicker {
            numRows = numberOfRows[component]
        }
        return numRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == regionPicker {
            if row == regionNames.count {
                return otherCountry[languageIndex]
            } else {
                return regionNames[row]
            }
        }
        else { //pickerView == weddingDatePicker
            if component == 0 {
                return String(describing: numDay[row])
            } else if component == 1 {
                return monthsLang[languageIndex][row]
            } else {
                return String(describing: numYear[row])
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == regionPicker {
            if row == regionNames.count {
                regionField.text = otherCountry[languageIndex]
            } else {
                regionField.text = regionNames[row]
            }
        }
        if pickerView == weddingDatePicker {
            let day = String(format: "%02ld", numDay[pickerView.selectedRow(inComponent: 0)] as CVarArg)
            
            monthCal = String(format: "%02ld", numMonths[pickerView.selectedRow(inComponent: 1)] as CVarArg)
            
            year = String(describing: numYear[pickerView.selectedRow(inComponent: 2)])
            
            weddingDateField.text = day + "/" + monthCal + "/" + year
            
            fullMonth = monthsLang[1][pickerView.selectedRow(inComponent: 1)] + " " + String(describing: numYear[pickerView.selectedRow(inComponent: 2)])
        }
    }
    
    func showCountryView() {
        
        self.isEditing = false
        let popCountryView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountrySelectorView") as! SelectCountryViewController
        popCountryView.languageIndex = self.languageIndex
        self.addChildViewController(popCountryView)
        popCountryView.view.frame = self.view.frame
        popCountryView.delegate = self
        if !(self.view.gestureRecognizers?.isEmpty)! {
            self.view.gestureRecognizers?.removeLast()
        }
        self.view.addSubview(popCountryView.view)
        popCountryView.didMove(toParentViewController: self)
    }
    
    func setCountryField(country: String) {
        regionField.text = country
    }
    
     func pickregion(_ textField : UITextField){
        
        self.regionPicker.backgroundColor = UIColor.white
        textField.inputView = self.regionPicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
        toolBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: doneLang[languageIndex], style: .plain, target: self, action: #selector(HomeViewController.doneRegion))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancelLang[languageIndex], style: .plain, target: self, action: #selector(HomeViewController.cancelRegion))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func pickWeddingDate(_ textField : UITextField){
        
        self.weddingDatePicker.backgroundColor = UIColor.white
        textField.inputView = self.weddingDatePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
        toolBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: doneLang[languageIndex], style: .plain, target: self, action: #selector(HomeViewController.doneDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancelLang[languageIndex], style: .plain, target: self, action: #selector(HomeViewController.cancelDate))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func doneRegion() {
        regionField.resignFirstResponder()
    }
    func cancelRegion() {
        regionField.text = ""
        regionField.resignFirstResponder()
    }
    func doneDate() {
        weddingDateField.resignFirstResponder()
    }
    func cancelDate() {
        weddingDateField.text = ""
        weddingDateField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == regionField {
            if textField.text == otherCountry[languageIndex] {
                showCountryView()
            }
        }
    }
    
    @IBAction func createProfile(sender: UIButton) {
        if nameField.text == "" || lastnameField.text == "" || emailField.text == "" || phoneField.text == "" || regionField.text == "" || weddingDateField.text == "" {
            let alertController = UIAlertController(title: warningMessageLang[languageIndex][0], message: warningMessageLang[languageIndex][1], preferredStyle: .alert)
            let alertAction = UIAlertAction(title: warningMessageLang[languageIndex][2], style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            resetHomeSettings()
        } else {
            provCart = Cart(name: (nameField.text?.capitalized)!, lastname: lastnameField.text!, email: (emailField.text?.lowercased())!, phone: phoneField.text!, city: regionField.text!, weddingDate: weddingDateField.text!, dresses: [""])
            
            lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            catalogButton.isEnabled = true
            catalogButton.alpha = 1
            
            month.append(monthCal + year)
            month.append(fullMonth)
            print(month)
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
            destinationController.month = month
        }
    }
    
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() { view.endEditing(true) }
}
