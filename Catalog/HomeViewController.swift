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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var createProfileButton: UIButton!
    
    @IBOutlet weak var lowSeparator: UIView!
    @IBOutlet weak var lowText: UILabel!
    @IBOutlet weak var catalogButton: UIButton!
    
    var pickerId = "regionPicker"
    var regionPicker = UIPickerView()
    var dateOfWeddingPicker = UIDatePicker()
    let toolBar = UIToolbar()
    var countrySelected = false
    var country: Country!
    var regionSelected = [String]()

    var regionNames = LocalData.getRegions()
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
            pickerId = "regionPicker"
            self.showRegionPicker()
        }
        if textField == dateOfWeddingField {
            pickerId = "dateOfWeddingPicker"
            self.showDateOfWeddingPicker()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regionNames.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == regionNames.count {
            return LocalData.getLocalizationLabels(forElement: "otherCountry")[languageIndex]
        } else {
            return regionNames[row][languageIndex]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == regionPicker {
            if row == regionNames.count {
                regionField.text = LocalData.getLocalizationLabels(forElement: "otherCountry")[languageIndex]
            } else {
                regionField.text = regionNames[row][languageIndex]
                regionSelected = regionNames[row]
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
        regionField.text = regionNames[regionPicker.selectedRow(inComponent: 0)][languageIndex]
        
        regionPicker.target(forAction: #selector(regionPickerChanged), withSender: self)
        
        formatToolBar()
        regionField.inputAccessoryView = toolBar
    }
    
    func regionPickerChanged() {
        regionField.text = regionNames[regionPicker.selectedRow(inComponent: 0)][languageIndex]
    }
    
    func showDateOfWeddingPicker() {
        
        dateOfWeddingPicker.datePickerMode = .date
        dateOfWeddingPicker.locale = Locale(identifier: LocalData.getLocalizationLabels(forElement: "dateLocal")[languageIndex])
        dateOfWeddingPicker.backgroundColor = .white
        dateOfWeddingPicker.minimumDate = Date()
        
        dateOfWeddingField.inputView = dateOfWeddingPicker
        dateOfWeddingPicker.addTarget(self, action: #selector(dateOfWeddingPickerChanged(sender:)), for: .valueChanged)
        
        formatToolBar()
        dateOfWeddingField.inputAccessoryView = toolBar
    }
    
    func dateOfWeddingPickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateOfWeddingField.text = dateFormatter.string(from: sender.date)
    }
    
    private func formatToolBar() {
        
        toolBar.barStyle = .default
        toolBar.isOpaque = true
        toolBar.barTintColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
        toolBar.tintColor = .white
        toolBar.sizeToFit()
        
        let doneRegionSelector = #selector(HomeViewController.doneRegion)
        let cancelRegionSelector = #selector(HomeViewController.cancelRegion)
        let doneDateSelector = #selector(HomeViewController.doneDate)
        let cancelDateSelector = #selector(HomeViewController.cancelDate)
        
        let doneButton = UIBarButtonItem(title: LocalData.getLocalizationLabels(forElement: "doneButton")[languageIndex], style: .plain, target: self, action:
            pickerId == "dateOfWeddingPicker" ? doneDateSelector : doneRegionSelector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: LocalData.getLocalizationLabels(forElement: "cancelButton")[languageIndex], style: .plain, target: self, action:
            pickerId == "dateOfWeddingPicker" ? cancelDateSelector : cancelRegionSelector)
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
            if textField.text == LocalData.getLocalizationLabels(forElement: "otherCountry")[languageIndex] {
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
                region: countrySelected ? country.name[1] : regionSelected[1],
                dateOfWedding: dateOfWeddingField.text!,
                dressesNames: ""
            )
        } else {
            let alertController = UIAlertController(title: LocalData.getLocalizationLabels(forElement: "warningTitle")[languageIndex], message: LocalData.getLocalizationLabels(forElement: "warningMessage")[languageIndex], preferredStyle: .alert)
            let alertAction = UIAlertAction(title: LocalData.getLocalizationLabels(forElement: "warningButton")[languageIndex], style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            resetHomeSettings()
        }
        dismissKeyboard()
        self.performSegue(withIdentifier: "showCatalog", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showCatalog"{
            if provCart == nil {
                provCart = Customer(
                    // TODO: Set ID of shoping taken by UserDefault
                    shopId: "WRO-ID",
                    name: "",
                    surname: "",
                    region: "",
                    dateOfWedding: "",
                    dressesNames: "")
            }
            let destinationController = segue.destination as! CatalogViewController
            destinationController.languageIndex = languageIndex
            destinationController.provCart = provCart
            destinationController.region = countrySelected ? country.name : regionSelected
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
        
        beforeLabel.text = LocalData.getLocalizationLabels(forElement: "beforeLabel")[languageIndex]
        nameLabel.text = LocalData.getLocalizationLabels(forElement: "nameLabel")[languageIndex]
        surnameLabel.text = LocalData.getLocalizationLabels(forElement: "surnameLabel")[languageIndex]
        regionLabel.text = LocalData.getLocalizationLabels(forElement: "regionLabel")[languageIndex]
        regionPicker.selectRow(0, inComponent: 0, animated: false)
        formatToolBar()
        dateOfWeddingLabel.text = LocalData.getLocalizationLabels(forElement: "dateOfWeddingLabel")[languageIndex]
        dateOfWeddingPicker.locale = Locale(identifier: LocalData.getLocalizationLabels(forElement: "dateLocal")[languageIndex])
        infoLabel.text = LocalData.getLocalizationLabels(forElement: "infoLabel")[languageIndex]
        createProfileButton.setTitle(LocalData.getLocalizationLabels(forElement: "createProfileButton")[languageIndex], for: .normal)
        lowText.text = LocalData.getLocalizationLabels(forElement: "lowText")[languageIndex]
        catalogButton.setTitle(LocalData.getLocalizationLabels(forElement: "catalogButton")[languageIndex], for: .normal)
    }
    
    private func resetHomeSettings() {
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
