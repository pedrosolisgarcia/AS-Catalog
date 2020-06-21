import UIKit
import CoreData

class SelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var surnameLabel: UILabel!
  @IBOutlet weak var regionLabel: UILabel!
  @IBOutlet weak var dateOfWeddingLabel: UILabel!
  @IBOutlet weak var dressesLabel: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var backHomeScreen: UIBarButtonItem!
  @IBOutlet weak var stackSelection: UIStackView!
  
  var selectedDresses = [Dress]()
  var currentCustomer: Customer!
  var languageIndex: Int!
  var region = [String]()
  
  @IBAction func backToHomeScreen(_ sender: UIBarButtonItem) {
    
    clearAllVariables()
    self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
    self.dismiss(animated: false)
  }
  
  @IBAction func saveSelectionToCart(_ sender: UIButton) {
    
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
      
      if Reachability.isConnectedToNetwork() {
        CostumerService.sendCostumerToAPI(customer: self.getFinalCustomer()) { (data, resp, error) in
          if let error = error {
            print(error.localizedDescription)
            print("error in BackEnd - Saving in Core Data")
            CoreDataManager.saveCustomerInCoreData(customer: self.getFinalCustomer(), viewContext: appDelegate.persistentContainer.viewContext)
            appDelegate.saveContext()
          }
        }
      } else {
        print("NO INTERNET - Saving in Core Data")
        CoreDataManager.saveCustomerInCoreData(customer: getFinalCustomer(), viewContext: appDelegate.persistentContainer.viewContext)
        appDelegate.saveContext()
      }
      
      showCompleteView()
      setViewAsCompleted()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    backHomeScreen.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
    applyLanguage()
    formatSelectedDressesSection()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedDresses.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
      as! SelectionTableViewCell
    let dress = selectedDresses[indexPath.row]
    
    cell.dressLabel.font = UIFont(name: "TrajanPro-Regular", size: 32)
    cell.dressLabel.text = dress.name.count > 1 ? dress.name[languageIndex] : dress.name[0]
    cell.dressImageView.image = UIImage(named: dress.imgName)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let popImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectedDressView") as! SelectedDressViewController
    popImageView.dressImage = selectedDresses[indexPath.row].imgName
    self.addChild(popImageView)
    popImageView.view.frame = self.view.frame
    self.view.addSubview(popImageView.view)
    self.navigationController?.view.addSubview(popImageView.view)
    popImageView.didMove(toParent: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  private func applyLanguage() {
    nameLabel.text = LocalData.getLocalizationLabels(forElement: "nameLabel")[languageIndex] + " " + currentCustomer.name
    surnameLabel.text = LocalData.getLocalizationLabels(forElement: "surnameLabel")[languageIndex] + " " + currentCustomer.surname
    regionLabel.text = LocalData.getLocalizationLabels(forElement: "regionLabel")[languageIndex] + " " + (!region.isEmpty ? region[languageIndex] : "")
    dateOfWeddingLabel.text = LocalData.getLocalizationLabels(forElement: "dateOfWeddingLabel")[languageIndex] + " " + currentCustomer.dateOfWedding
    saveButton.setTitle(LocalData.getLocalizationLabels(forElement: "saveButton")[languageIndex], for: .normal)
    navigationItem.title = LocalData.getLocalizationLabels(forElement: "selectionTitle")[languageIndex]
    dressesLabel.setTitle(LocalData.getLocalizationLabels(forElement: "selectionTitle")[languageIndex], for: .normal)
    backHomeScreen.title = LocalData.getLocalizationLabels(forElement: "backHomeScreen")[languageIndex]
  }
  
  private func clearAllVariables() {
    currentCustomer = nil
    selectedDresses.removeAll()
    tableView = nil
  }
  
  private func formatSelectedDressesSection() {
    let maskPathSave = UIBezierPath(roundedRect: saveButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
    
    let maskLayerSave = CAShapeLayer()
    maskLayerSave.path = maskPathSave.cgPath
    saveButton.layer.mask = maskLayerSave
    
    let maskPathLabel = UIBezierPath(roundedRect: dressesLabel.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
    
    let maskLayerLabel = CAShapeLayer()
    maskLayerLabel.path = maskPathLabel.cgPath
    dressesLabel.layer.mask = maskLayerLabel
  }
  
  private func getFinalCustomer() -> Customer {
    if !self.region.isEmpty {
      currentCustomer.region = self.region[1]
    }
    return currentCustomer
  }
  
  private func setViewAsCompleted() {
    saveButton.isEnabled = false
    saveButton.alpha = 0.25
    self.navigationItem.hidesBackButton = true
    backHomeScreen.tintColor = .white
    backHomeScreen.isEnabled = true
  }
  
  private func showCompleteView() {
    let popCompleteView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompleteView") as! CompleteViewController
    popCompleteView.languageIndex = self.languageIndex
    self.addChild(popCompleteView)
    popCompleteView.view.frame = self.view.frame
    self.view.addSubview(popCompleteView.view)
    self.navigationController?.view.addSubview(popCompleteView.view)
    popCompleteView.didMove(toParent: self)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
