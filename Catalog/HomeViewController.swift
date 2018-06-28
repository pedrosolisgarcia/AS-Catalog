import UIKit
import CoreData

class HomeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var polishButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    @IBOutlet weak var beforeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameWarning: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var regionField: UITextField!
    @IBOutlet weak var dateOfWeddingLabel: UILabel!
    @IBOutlet weak var dateOfWeddingField: UITextField!
    @IBOutlet weak var createProfileButton: UIButton!
    
    @IBOutlet weak var lowSeparator: UIView!
    @IBOutlet weak var lowText: UILabel!
    @IBOutlet weak var catalogButton: UIButton!
    
    var regionPicker = UIPickerView()
    var dateOfWeddingPicker = UIPickerView()
    
    var beforeLang: [String] = ["Przed obejrzeniem katalogu, proszę o identyfikację:","Before watching the catalog, please identify yourself:","Antes de ver el catalogo, por favor identifícate:"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var surnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var regionLang = ["Województwo:","Region:","Región:"]
    var otherCountry = ["Nie jestem z Polski..", "I am not from Poland..", "No soy de Polonia.."]
    var regionNames = ["dolnośląskie", "kujawsko-pomorskie", "lubelskie", "lubuskie", "łódzkie", "małopolskie", "mazowieckie", "opolskie", "podkarpackie", "podlaskie", "pomorskie", "śląskie", "świętokrzyskie", "warmińsko-mazurskie", "wielkopolskie", "zachodniopomorskie"]
    var dateOfWeddingLang = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    var numDay = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    var numMonths = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    var numYear = [2018,2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030]
    var monthsLang = [["styczeń", "luty", "marzec", "kwiecień", "maj", "czerwiec", "lipiec", "sierpień", "wrzesień", "październik", "listopad", "grudzień"], ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]]
    var numberOfRows = [31,12,13]
    var doneLang: [String] = ["Gotowy","Done","Hecho"]
    var cancelLang: [String] = ["Anuluj","Cancel","Cancelar"]
    var createProfileLang: [String] = ["UTWÓRZ PROFIL","CREATE PROFILE","CREAR PERFIL"]
    var warningMessageLang: [[String]] = [["Błąd","Wszystkie pola muszą być wypełnione, aby zobaczyć katalog.","Dobra"],["Error","All the fields must be filled to see the catalog.","Ok"],["Error","Todos los campos han de ser rellenados para poder ver el catálogo.","Vale"]]
    var lowTextLang: [String] = ["Możesz zobaczyć katalog.","Now you can watch the catalog.","Ya puedes ver el catálogo."]
    var catalogLang: [String] = ["OBEJRZYJ KATALOG","WATCH THE CATALOG","VISITA EL CATÁLOGO"]
    var languageIndex: Int!
    static var selectedCountry = ""
    
    var provCart: Customer!
    var monthCal: String!
    var year: String!
    var month = [String]()
    var fullMonth: String!
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue){
        if segue.identifier == "unwindToHomeScreen" {
            sendPendingCostumersToAPIIfConnected()
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
        surnameLabel.text = surnameLang[languageIndex]
        regionLabel.text = regionLang[languageIndex]
        dateOfWeddingLabel.text = dateOfWeddingLang[languageIndex]
        createProfileButton.setTitle(createProfileLang[languageIndex], for: .normal)
        lowText.text = lowTextLang[languageIndex]
        catalogButton.setTitle(catalogLang[languageIndex], for: .normal)
        dateOfWeddingPicker.reloadComponent(1)
    }
    
    //TODO: to put core data logic ALSO in unwindToHomeScreen
    override func viewDidLoad() {
        super.viewDidLoad()
        languageIndex = 0
        regionPicker.delegate = self
        dateOfWeddingPicker.delegate = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        
        sendPendingCostumersToAPIIfConnected()
        resetHomeSettings()
        hideKeyboard()
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
        if textField == dateOfWeddingField {
            self.pickdateOfWedding(self.dateOfWeddingField)
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        if textField == nameField {
//            textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ? (nameWarning.isHidden = false) : (nameWarning.isHidden = true)
//
//        }
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var numComponents = 0
        if pickerView == regionPicker {
            numComponents = 1
        }
        if pickerView == dateOfWeddingPicker {
            numComponents = 3
        }
        return numComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numRows = 0
        if pickerView == regionPicker {
            numRows = regionNames.count + 1
        }
        if pickerView == dateOfWeddingPicker {
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
        else {
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
        if pickerView == dateOfWeddingPicker {
            let day = String(format: "%02ld", numDay[pickerView.selectedRow(inComponent: 0)] as CVarArg)
            
            monthCal = String(format: "%02ld", numMonths[pickerView.selectedRow(inComponent: 1)] as CVarArg)
            
            year = String(describing: numYear[pickerView.selectedRow(inComponent: 2)])
            
            dateOfWeddingField.text = day + "/" + monthCal + "/" + year
            
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
    
    func pickdateOfWedding(_ textField : UITextField){
        
        self.dateOfWeddingPicker.backgroundColor = UIColor.white
        monthCal = String(format: "%02ld", numMonths[dateOfWeddingPicker.selectedRow(inComponent: 1)] as CVarArg)
        year = String(describing: numYear[dateOfWeddingPicker.selectedRow(inComponent: 2)])
        fullMonth = monthsLang[1][dateOfWeddingPicker.selectedRow(inComponent: 1)] + " " + String(describing: numYear[dateOfWeddingPicker.selectedRow(inComponent: 2)])
        textField.inputView = self.dateOfWeddingPicker
        textField.text = String(format: "%02ld", numDay[dateOfWeddingPicker.selectedRow(inComponent: 0)] as CVarArg)
            + "/" + monthCal + "/" + year
        
        
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
        dateOfWeddingField.resignFirstResponder()
    }
    func cancelDate() {
        dateOfWeddingField.text = ""
        dateOfWeddingField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == regionField {
            if textField.text == otherCountry[languageIndex] {
                showCountryView()
            }
        }
    }
    
    @IBAction func createProfile(sender: UIButton) {
        if (Validator.validate(name: nameField.text!, surname: surnameField.text!, region: regionField.text!, weddingDate: dateOfWeddingField.text!)) {
            provCart = Customer(
                // TODO: Set ID of shoping taken by UserDefault
                shopId: "WRO-ID",
                name: (nameField.text?.capitalized)!,
                surname: (surnameField.text?.capitalized)!,
                region: regionField.text!,
                dateOfWedding: dateOfWeddingField.text!,
                dressesNames: ""
            )
            
            lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            catalogButton.isEnabled = true
            catalogButton.alpha = 1
            
            month.append(year + monthCal)
            month.append(fullMonth)
        } else {
            let alertController = UIAlertController(title: warningMessageLang[languageIndex][0], message: warningMessageLang[languageIndex][1], preferredStyle: .alert)
            let alertAction = UIAlertAction(title: warningMessageLang[languageIndex][2], style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            resetHomeSettings()
        }
        dismissKeyboard()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func sendPendingCostumersToAPIIfConnected() {
        
        if Reachability.isConnectedToNetwork() {
            
            var customersMO = CoreDataManager.fetchCustomersFromCoreData(delegate: self)
            for customerMO in customersMO.enumerated() {
                
                let customer = CustomerMapper.mapCustomerMOToCustomer(customerMO: customerMO.element)
                APIConnector.sendCostumerToAPI(customer: customer) { (data, resp, error) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    print("error en SELECTION VIEW CONTROLLER")
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        CoreDataManager.saveCustomerInCoreData(customer: customer, viewContext: appDelegate.persistentContainer.viewContext)
                        appDelegate.saveContext()
                    }
                }
                
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    context.delete(customerMO.element)
                    appDelegate.saveContext()
                }
                customersMO.removeFirst()
            }
        }
    }
    
    private func resetHomeSettings() {
        lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        catalogButton.isEnabled = false
        catalogButton.alpha = 0
        nameWarning.isHidden = true
    }
    
    private func resetHomeFields() {
        languageIndex = 0
        applyLanguage()
        provCart = nil
        nameField.text = nil
        surnameField.text = nil
        regionField.text = nil
        regionPicker.reloadAllComponents()
        dateOfWeddingField.text = nil
        dateOfWeddingPicker.reloadAllComponents()
        month.removeAll()
    }
}
