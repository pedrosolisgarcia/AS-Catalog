import UIKit
import CoreData

class HomeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate {
  
  let appVersion = "4.00"
  
  var pickerId = "regionPicker"
  var regionPicker = UIPickerView()
  var dateOfWeddingPicker = UIDatePicker()
  let toolBar = UIToolbar()
  var countrySelected = false
  var country: Country!
  var regionSelected = String()
  
  var regionNames = LocalData.getRegions()
  var languageIndex: Int!
  static var selectedCountry = ""
  
  var currentClient: Client!
  var monthCal: String!
  var year: String!
  var month = [String]()
  var fullMonth: String!
  
  @IBOutlet weak var polishButton: UIButton!
  @IBOutlet weak var englishButton: UIButton!
  @IBOutlet weak var spanishButton: UIButton!
  @IBOutlet weak var beforeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var surnameLabel: UILabel!
  @IBOutlet weak var surnameField: UITextField!
  @IBOutlet weak var regionLabel: UILabel!
  @IBOutlet weak var regionField: UITextField!
  @IBOutlet weak var dateOfWeddingLabel: UILabel!
  @IBOutlet weak var dateOfWeddingField: UITextField!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var createProfileButton: UIButton!
  
  @IBOutlet weak var lowSeparator: UIView!
  @IBOutlet weak var catalogButton: UIButton!
  
  var collection: Collection!
  
  let locale = NSLocale.current.languageCode
  
  let appLocale = Locale.preferredLanguages[0]
  
  @IBAction func createProfile(sender: UIButton) {
    if sender == self.createProfileButton {
      if (ClientDataValidator.validate(name: nameField.text!, surname: surnameField.text!, region: regionField.text!, weddingDate: dateOfWeddingField.text!)) {
        self.setCurrentClientData()
      } else {
        self.showDataInvalidWarningMessage()
      }
      view.endEditing(true)
    }
    do {
      let fullPath = self.getDocumentsDirectory().appendingPathComponent("DRESS_COLLECTION")
      print(fullPath)
      
      guard  let data = try? Data(contentsOf: fullPath, options: []) else {
        self.showNoCatalogAlert()
        return
      }

      let loadedUserData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Data
      self.collection = try JSONDecoder().decode(Collection.self, from: loadedUserData)
      print(self.collection!)
      self.performSegue(withIdentifier: "showCatalog", sender: self)
    } catch {
      self.showNoCatalogAlert()
      print("Couldn't read file.")
    }
  }
  
  @IBAction func pressToShowShopIdView(sender: UIButton) {
    self.showShopIdView()
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
  
  @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue){
    if segue.identifier == "unwindToHomeScreen" {
      sendPendingClientsToAPIIfConnected()
      resetHomeFields()
    }
    if segue.identifier == "unwindToPolishRegion" {
      self.showRegionPicker()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    languageIndex = 0
    
    print(locale, appLocale)
    
    if !ShopIdServiceAPI.shared.hasRegisteredShopId() {
      showShopIdView()
    }
    
    regionPicker.delegate = self
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    
    selectLanguage(sender: polishButton)
    sendPendingClientsToAPIIfConnected()
    self.view.addDismissKeyboardListener()
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
      return "region-picker.other-region".localized()
    } else {
      return regionNames[row].localized()
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == regionPicker {
      if row == regionNames.count {
        regionField.text = "region-picker.other-region".localized()
      } else {
        regionField.text = regionNames[row].localized()
        regionSelected = regionNames[row].localized()
        countrySelected = false
      }
    }
  }
  
  func showRegionPicker(){

    regionPicker.selectRow(0, inComponent: 0, animated: false)
    regionField.inputView = self.regionPicker
    regionField.text = regionNames[regionPicker.selectedRow(inComponent: 0)].localized()
    regionSelected = regionNames[regionPicker.selectedRow(inComponent: 0)]
    regionPicker.target(forAction: #selector(self.regionPickerChanged), withSender: self)
    
    formatToolBar()
    regionField.inputAccessoryView = toolBar
  }
  
  @objc func regionPickerChanged() {
    regionField.text = regionNames[regionPicker.selectedRow(inComponent: 0)]
  }
  
  func setCountryField(country: Country) {
    regionField.text = country.name.localized()
    countrySelected = true
    self.country = country
  }
  
  func showDateOfWeddingPicker() {
    
    dateOfWeddingPicker.datePickerMode = .date
//    dateOfWeddingPicker.locale = Locale(identifier: LocalData.getLocalizationLabels(forElement: "dateLocal")[languageIndex])
    dateOfWeddingPicker.minimumDate = Date()
    
    dateOfWeddingField.inputView = dateOfWeddingPicker
    dateOfWeddingPicker.addTarget(self, action: #selector(self.dateOfWeddingPickerChanged(sender:)), for: .valueChanged)
    
    formatToolBar()
    dateOfWeddingField.inputAccessoryView = toolBar
  }
  
  @objc func dateOfWeddingPickerChanged(sender: UIDatePicker) {
    dateOfWeddingField.text = formatDate(date: sender.date)
  }
  
  func formatToolBar() {
    
    toolBar.barStyle = .default
    toolBar.isOpaque = true
    toolBar.barTintColor = .golden
    toolBar.tintColor = .white
    toolBar.sizeToFit()
    
    let doneRegionSelector = #selector(self.doneRegion)
    let cancelRegionSelector = #selector((self.cancelRegion))
    let doneDateSelector = #selector(self.doneDate)
    let cancelDateSelector = #selector(self.cancelDate)
    
    let doneButton = UIBarButtonItem(
      title: "alert.done-button".localized(),
      style: .plain,
      target: self,
      action:
        pickerId == "dateOfWeddingPicker" ? doneDateSelector : doneRegionSelector
    )
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(
      title: "alert.cancel-button".localized(),
      style: .plain,
      target: self,
      action:
        pickerId == "dateOfWeddingPicker" ? cancelDateSelector : cancelRegionSelector
    )
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
  }
  
  @objc func doneRegion() {
    regionField.resignFirstResponder()
  }
  @objc func cancelRegion() {
    regionField.text = ""
    regionField.resignFirstResponder()
  }
  @objc func doneDate() {
    dateOfWeddingField.resignFirstResponder()
  }
  @objc func cancelDate() {
    dateOfWeddingField.text = ""
    dateOfWeddingField.resignFirstResponder()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == regionField {
      if textField.text == "region-picker.other-region".localized() {
        showCountryView()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "showCatalog"{
      if currentClient == nil {
        self.setCurrentClientData()
      }
      self.currentClient.collectionId = self.collection.id

      let destinationController = segue.destination as! CatalogViewController
      destinationController.collection = collection
      destinationController.currentClient = currentClient
      destinationController.region = countrySelected ? country.name : regionSelected
    }
  }
  
  private func applyLanguage() {
    
    beforeLabel.text = "home.client-info.label".localized()
    nameLabel.text = "home.client-info.name".localized()
    surnameLabel.text = "home.client-info.lastname".localized()
    regionLabel.text = "home.client-info.region".localized()
    regionPicker.selectRow(0, inComponent: 0, animated: false)
    formatToolBar()
    dateOfWeddingLabel.text = "home.client-info.wedding-date".localized()
//    dateOfWeddingPicker.locale = Locale(identifier: LocalData.getLocalizationLabels(forElement: "dateLocal")[languageIndex])
    infoLabel.text = "home.client-info.more-info".localized()
    createProfileButton.setTitle("home.client-info.button".localized().uppercased(), for: .normal)
    catalogButton.setTitle("home.catalog-button".localized().uppercased(), for: .normal)
  }
  
  private func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: date)
  }
  
  private func resetHomeFields() {
    languageIndex = 0
    applyLanguage()
    currentClient = nil
    nameField.text = nil
    surnameField.text = nil
    regionField.text = nil
    regionPicker.reloadAllComponents()
    dateOfWeddingPicker.setDate(Date(), animated: false)
    dateOfWeddingField.text = nil
    month.removeAll()
    regionSelected.removeAll()
    polishButton.alpha = 1
    englishButton.alpha = 0.5
    spanishButton.alpha = 0.5
  }
  
  private func sendPendingClientsToAPIIfConnected() {
    
    if Reachability.isConnectedToNetwork() {
      var clientsMO = CoreDataManager.getClientsFromCoreData(delegate: self)
      for clientMO in clientsMO.enumerated() {
        
        let client = ClientMapper.mapClientMOToClient(clientMO: clientMO.element )
        ClientService.sendClientToAPI(client: client) {
          (data, resp, error) in
          if let error = error {
            print(error.localizedDescription)
            print("error en SELECTION VIEW CONTROLLER")
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
              CoreDataManager.saveClientInCoreData(client: client, viewContext: appDelegate.persistentContainer.viewContext)
            }
          }
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
          let context = appDelegate.persistentContainer.viewContext
          context.delete(clientMO.element as NSManagedObject)

          do {
            try context.save()
            
          } catch let error as NSError {
            print(error)
          }
        }
        clientsMO.removeFirst()
      }
    }
  }
  
  private func setCurrentClientData() {
    currentClient = Client(
      appVersion: self.appVersion,
      dateOfVisit: formatDate(date: Date()),
      shopId: ShopIdServiceAPI.shared.getShopId()!,
      name: (nameField.text?.capitalized)!,
      surname: (surnameField.text?.capitalized)!,
      region: regionField.text!,
      dateOfWedding: dateOfWeddingField.text!,
      dressesNames: "",
      collectionId: 0
    )
  }
  
  private func showDataInvalidWarningMessage() {
    let alertController = UIAlertController(
      title: "alert.error.title".localized(),
      message: "alert.create-profile-error.message".localized(),
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: "alert.ok-button".localized(),
      style: .default,
      handler: nil
    )
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion:nil)
  }
  
  func showNoCatalogAlert() {
    let alertController = UIAlertController(
      title: "alert.error.title".localized(),
      message: "alert.no-catalog-error.message".localized(),
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: "alert.no-catalog-error.button".localized(),
      style: .default
    ) {
      (alert: UIAlertAction!) -> Void in
        self.showShopIdView()
    }
    alertController.addAction(alertAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  private func showCountryView() {
    self.isEditing = false
    let popCountryView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountrySelectorView") as! CountrySelectorViewController
    self.addChild(popCountryView)
    popCountryView.view.frame = self.view.frame
    popCountryView.delegate = self
    self.view.addSubview(popCountryView.view)
    popCountryView.didMove(toParent: self)
  }
  
  private func showShopIdView() {
    let popShopIdView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shopIdView") as! ShopIDViewController
    self.addChild(popShopIdView)
    popShopIdView.view.frame = self.view.frame
    self.view.addSubview(popShopIdView.view)
    popShopIdView.didMove(toParent: self)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
