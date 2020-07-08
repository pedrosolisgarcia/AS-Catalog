import UIKit
import CoreData

class HomeViewController: UIViewController {
  
  let appVersion = "4.00"
  
  var pickerId = "regionPicker"
  var regionPicker = UIPickerView()
  var dateOfWeddingPicker = UIDatePicker()
  let toolBar = UIToolbar()
  var hasCountrySelected = false
  var country: Country!
  var regionSelected = String()
  
  var regions: [String] = LocalDataService.shared.getRegions()!
  
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
  @IBOutlet weak var catalogButton: UIButton!
  
  var collection: Collection!

  private let langService: LanguageService = LanguageService.shared
  private let shopIdService: ShopIdServiceAPI = ShopIdServiceAPI.shared
  
  override func viewDidLoad() -> Void {
    super.viewDidLoad()
    
    if !self.shopIdService.hasRegisteredShopId() {
      showShopIdView()
    }
    self.delegateRegionPicker()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    
    selectLanguage(sender: polishButton)
    translateTextKeys()
    sendPendingClientsToAPIIfConnected()
    self.view.addDismissKeyboardListener()
  }
  
  @IBAction func createProfile(sender: UIButton) {
    if sender == self.createProfileButton {
      if !ClientDataValidator.validate(
        name: nameField.text!,
        surname: surnameField.text!,
        region: regionField.text!,
        weddingDate: dateOfWeddingField.text!
      ) {
        self.showInvalidDataAlert()
        return
      }
    }
    self.getLocalCollection()
  }
  
  @IBAction func pressToShowShopIdView(sender: UIButton) -> Void {
    self.showShopIdView()
  }
  
  @IBAction func selectLanguage(sender: UIButton) -> Void {
    
    if sender == polishButton  {
      langService.setLanguage(to: "pl")
      polishButton.alpha = 1
      englishButton.alpha = 0.5
      spanishButton.alpha = 0.5
    }
    if sender == englishButton {
      langService.setLanguage(to: "en")
      polishButton.alpha = 0.5
      englishButton.alpha = 1
      spanishButton.alpha = 0.5
    }
    if sender == spanishButton {
      langService.setLanguage(to: "es")
      polishButton.alpha = 0.5
      englishButton.alpha = 0.5
      spanishButton.alpha = 1
    }
    translateTextKeys()
  }
  
  @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) -> Void {
    if segue.identifier == "unwindToHomeScreen" {
      sendPendingClientsToAPIIfConnected()
      resetHomeFields()
    }
    if segue.identifier == "unwindToPolishRegion" {
      self.showRegionPicker()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) -> Void {
    self.navigationController?.isNavigationBarHidden = true
  }
  
  func setCountryField(country: Country) -> Void {
    regionField.text = country.name.localized()
    hasCountrySelected = true
    self.country = country
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) -> Void {
    
    if segue.identifier == "showCatalog" {

      let destinationController = segue.destination as! CatalogViewController
      destinationController.collection = collection
      destinationController.clientData = self.getClientData()
      destinationController.region = hasCountrySelected ? country.name : regionSelected
    }
  }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------

extension HomeViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) -> Void {
    if textField == regionField {
      pickerId = "regionPicker"
      self.showRegionPicker()
    }
    if textField == dateOfWeddingField {
      pickerId = "dateOfWeddingPicker"
      self.showDateOfWeddingPicker()
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) -> Void {
    if textField == regionField {
      if textField.text == "region-picker.other-region".localized() {
        showCountryView()
      }
    }
  }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------

extension HomeViewController: UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return regions.count + 1
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if row == regions.count {
      return "region-picker.other-region".localized()
    } else {
      return regions[row].localized()
    }
  }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------

extension HomeViewController: UIPickerViewDelegate {

  private func delegateRegionPicker() -> Void {
    regionPicker.delegate = self
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) -> Void {
    if pickerView == regionPicker {
      if row == regions.count {
        regionField.text = "region-picker.other-region".localized()
      } else {
        regionField.text = regions[row].localized()
        regionSelected = regions[row].localized()
        hasCountrySelected = false
      }
    }
  }
  
  @objc func regionPickerChanged() -> Void {
    regionField.text = regions[regionPicker.selectedRow(inComponent: 0)]
  }
  
  @objc func dateOfWeddingPickerChanged(sender: UIDatePicker) -> Void {
    dateOfWeddingField.text = formatDate(date: sender.date)
  }
  
  @objc func doneRegion() -> Void {
    regionField.resignFirstResponder()
  }
  @objc func cancelRegion() -> Void {
    regionField.text = ""
    regionField.resignFirstResponder()
  }
  @objc func doneDate() -> Void {
    dateOfWeddingField.resignFirstResponder()
  }
  @objc func cancelDate() -> Void {
    dateOfWeddingField.text = ""
    dateOfWeddingField.resignFirstResponder()
  }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------

extension HomeViewController: NSFetchedResultsControllerDelegate {

  private func sendPendingClientsToAPIIfConnected() -> Void {
    
    if Reachability.isConnectedToNetwork() {
      var clientsMO = CoreDataManager.getClientsFromCoreData(delegate: self)
      for clientMO in clientsMO.enumerated() {
        
        let client = ClientMapper.mapClientMOToClient(clientMO: clientMO.element )
        ClientService.sendClientToAPI(client: client) {
          (data, resp, error) in
          if let error = error {
            print(error.localizedDescription)
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
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------

extension HomeViewController {
  
  private func translateTextKeys() -> Void {
    beforeLabel.text = "home.client-info.label".localized()
    nameLabel.text = "home.client-info.name".localized()
    surnameLabel.text = "home.client-info.lastname".localized()
    regionLabel.text = "home.client-info.region".localized()
    regionPicker.selectRow(0, inComponent: 0, animated: false)
    formatToolBar()
    dateOfWeddingLabel.text = "home.client-info.wedding-date".localized()
    dateOfWeddingPicker.locale = Locale(identifier: langService.getCurrentLanguage() ?? "pl")
    infoLabel.text = "home.client-info.more-info".localized()
    createProfileButton.setTitle("home.client-info.button".localized().uppercased(), for: .normal)
    catalogButton.setTitle("home.catalog-button".localized().uppercased(), for: .normal)
  }
  
  private func showRegionPicker() -> Void {
    regionPicker.selectRow(0, inComponent: 0, animated: false)
    regionField.inputView = self.regionPicker
    regionField.text = regions[regionPicker.selectedRow(inComponent: 0)].localized()
    regionSelected = regions[regionPicker.selectedRow(inComponent: 0)].localized()
    regionPicker.target(forAction: #selector(self.regionPickerChanged), withSender: self)
    
    formatToolBar()
    regionField.inputAccessoryView = toolBar
  }
  
  private func showDateOfWeddingPicker() -> Void {
    dateOfWeddingPicker.datePickerMode = .date
    dateOfWeddingPicker.locale = Locale(identifier: langService.getCurrentLanguage() ?? "pl")
    dateOfWeddingPicker.minimumDate = Date()
    
    dateOfWeddingField.inputView = dateOfWeddingPicker
    dateOfWeddingPicker.addTarget(self, action: #selector(self.dateOfWeddingPickerChanged(sender:)), for: .valueChanged)
    
    formatToolBar()
    dateOfWeddingField.inputAccessoryView = toolBar
  }
  
  private func formatToolBar() -> Void {
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
  
  private func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: date)
  }
  
  private func resetHomeFields() -> Void {
    translateTextKeys()
    nameField.text = nil
    surnameField.text = nil
    regionField.text = nil
    regionPicker.reloadAllComponents()
    dateOfWeddingPicker.setDate(Date(), animated: false)
    dateOfWeddingField.text = nil
    regionSelected.removeAll()
    polishButton.alpha = 1
    englishButton.alpha = 0.5
    spanishButton.alpha = 0.5
  }
  
  private func getClientData() -> Client {
    return Client(
      appVersion: self.appVersion,
      dateOfVisit: formatDate(date: Date()),
      shopId: self.shopIdService.getShopId()!,
      name: (nameField.text?.capitalized)!,
      surname: (surnameField.text?.capitalized)!,
      region: regionField.text!,
      dateOfWedding: dateOfWeddingField.text!,
      dressesNames: "",
      collectionId: self.collection.id
    )
  }
  
  private func showCountryView() -> Void {
    let popCountryView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountrySelectorView") as! CountrySelectorViewController
    self.addChild(popCountryView)
    popCountryView.view.frame = self.view.frame
    popCountryView.delegate = self
    self.view.addSubview(popCountryView.view)
    popCountryView.didMove(toParent: self)
  }
  
  private func showShopIdView() -> Void {
    let popShopIdView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shopIdView")
    self.addChild(popShopIdView)
    popShopIdView.view.frame = self.view.frame
    self.view.addSubview(popShopIdView.view)
    popShopIdView.didMove(toParent: self)
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

  private func getLocalCollection() -> Void {
    do {
      let fullPath = self.getDocumentsDirectory().appendingPathComponent("DRESS_COLLECTION")
      
      guard  let data = try? Data(contentsOf: fullPath, options: []) else {
        self.showNoCatalogAlert()
        return
      }

      let loadedUserData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Data
      self.collection = try JSONDecoder().decode(Collection.self, from: loadedUserData)
      self.performSegue(withIdentifier: "showCatalog", sender: self)
    } catch {
      self.showNoCatalogAlert()
      print("Couldn't read file.")
    }
  }
  
  private func showInvalidDataAlert() -> Void {
    self.displaySingleActionAlert(
      title: "alert.error.title",
      message: "alert.create-profile-error.message",
      actionTitle: "alert.ok-button",
      action: nil
    )
  }
  
  private func showNoCatalogAlert() -> Void {
    self.displaySingleActionAlert(
      title: "alert.error.title",
      message: "alert.no-catalog-error.message",
      actionTitle: "alert.no-catalog-error.button",
      action: {
        (alert: UIAlertAction!) -> Void in
          self.showShopIdView()
      }
    )
  }
}
