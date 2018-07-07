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
    var dateOfWeddingPicker = UIDatePicker()
    let toolBar = UIToolbar()
    var countrySelected = false
    var country: Country!
    
    var beforeLang: [String] = ["Przed obejrzeniem katalogu, proszę o identyfikację:","Before watching the catalog, please identify yourself:","Antes de ver el catalogo, por favor identifícate:"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var surnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var regionLang = ["Województwo:","Region:","Región:"]
    var otherCountry = ["Nie jestem z Polski..", "I am not from Poland..", "No soy de Polonia.."]
    var regionNames = ["dolnośląskie", "kujawsko-pomorskie", "lubelskie", "lubuskie", "łódzkie", "małopolskie", "mazowieckie", "opolskie", "podkarpackie", "podlaskie", "pomorskie", "śląskie", "świętokrzyskie", "warmińsko-mazurskie", "wielkopolskie", "zachodniopomorskie"]
    var dateOfWeddingLang = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    let dateLocal = ["pl","en","es"]
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
            self.showRegionPicker()
        }
    }
    
    @IBAction func selectLanguage(sender: UIButton) {
        
        if sender == polishButton  {
            languageIndex = 0
            polishButton.alpha = 1
            englishButton.alpha = 0.5
            spanishButton.alpha = 0.5
        }
        if sender == englishButton {
            languageIndex = 1
            polishButton.alpha = 0.5
            englishButton.alpha = 1
            spanishButton.alpha = 0.5
        }
        if sender == spanishButton {
            languageIndex = 2
            polishButton.alpha = 0.5
            englishButton.alpha = 0.5
            spanishButton.alpha = 1
        }
        applyLanguage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageIndex = 0
        regionPicker.delegate = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        
        selectLanguage(sender: polishButton)
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
            self.showRegionPicker()
        }
        if textField == dateOfWeddingField {
            self.showDateOfWeddingPicker()
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        if textField == nameField {
//            textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ? (nameWarning.isHidden = false) : (nameWarning.isHidden = true)
//
//        }
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regionNames.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == regionNames.count {
            return otherCountry[languageIndex]
        } else {
            return regionNames[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == regionPicker {
            if row == regionNames.count {
                regionField.text = otherCountry[languageIndex]
            } else {
                regionField.text = regionNames[row]
                countrySelected = false
            }
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
    
    func setCountryField(country: Country) {
        regionField.text = country.name[languageIndex]
        countrySelected = true
        self.country = country
    }
    
    func showRegionPicker(){
        
        self.regionPicker.backgroundColor = UIColor.white
        regionPicker.selectRow(0, inComponent: 0, animated: false)
        regionField.inputView = self.regionPicker
        regionField.text = regionNames[regionPicker.selectedRow(inComponent: 0)]
        
        regionPicker.target(forAction: #selector(regionPickerChanged), withSender: self)
        
        formatToolBar(tag: "region")
        regionField.inputAccessoryView = toolBar
    }
    
    func regionPickerChanged() {
        regionField.text = regionNames[regionPicker.selectedRow(inComponent: 0)]
    }
    
    func showDateOfWeddingPicker() {
        
        dateOfWeddingPicker.datePickerMode = .date
        dateOfWeddingPicker.locale = Locale(identifier: dateLocal[languageIndex])
        dateOfWeddingPicker.backgroundColor = .white
        dateOfWeddingPicker.minimumDate = Date()
        
        dateOfWeddingField.inputView = dateOfWeddingPicker
        dateOfWeddingPicker.addTarget(self, action: #selector(dateOfWeddingPickerChanged(sender:)), for: .valueChanged)
        
        formatToolBar(tag: "date")
        dateOfWeddingField.inputAccessoryView = toolBar
    }
    
    func dateOfWeddingPickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateOfWeddingField.text = dateFormatter.string(from: sender.date)
    }
    
    private func formatToolBar(tag: String) {
        
        toolBar.barStyle = .default
        toolBar.isOpaque = true
        toolBar.barTintColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
        toolBar.tintColor = .white
        toolBar.sizeToFit()
        
        let doneRegionSelector = #selector(HomeViewController.doneRegion)
        let cancelRegionSelector = #selector(HomeViewController.cancelRegion)
        let doneDateSelector = #selector(HomeViewController.doneDate)
        let cancelDateSelector = #selector(HomeViewController.cancelDate)
        
        let doneButton = UIBarButtonItem(title: doneLang[languageIndex], style: .plain, target: self, action:
            tag == "date" ? doneDateSelector : doneRegionSelector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancelLang[languageIndex], style: .plain, target: self, action:
            tag == "date" ? cancelDateSelector : cancelRegionSelector)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
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
                region: countrySelected ? country.name[1] : regionField.text!,
                dateOfWedding: dateOfWeddingField.text!,
                dressesNames: ""
            )
            
            lowText.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            catalogButton.isEnabled = true
            catalogButton.alpha = 1
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
    
    private func applyLanguage() {
        
        beforeLabel.text = beforeLang[languageIndex]
        nameLabel.text = nameLang[languageIndex]
        surnameLabel.text = surnameLang[languageIndex]
        regionLabel.text = regionLang[languageIndex]
        regionPicker.selectRow(0, inComponent: 0, animated: false)
        formatToolBar(tag: "region")
        dateOfWeddingLabel.text = dateOfWeddingLang[languageIndex]
        dateOfWeddingPicker.locale = Locale(identifier: dateLocal[languageIndex])
        createProfileButton.setTitle(createProfileLang[languageIndex], for: .normal)
        lowText.text = lowTextLang[languageIndex]
        catalogButton.setTitle(catalogLang[languageIndex], for: .normal)
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
        month.removeAll()
    }
}
