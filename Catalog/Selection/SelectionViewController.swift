import UIKit

class SelectionViewController: UIViewController {
  
  let langService: LanguageService = LanguageService.shared
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var surnameLabel: UILabel!
  @IBOutlet weak var regionLabel: UILabel!
  @IBOutlet weak var dateOfWeddingLabel: UILabel!
  @IBOutlet weak var dressesLabel: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var backHomeScreen: UIBarButtonItem!
  @IBOutlet weak var stackSelection: UIStackView!
  
  var selectedDresses = [CollectionDresses]()
  var clientData: Client!
  var region = String()
  var collectionId: Int!
  
  @IBAction func backToHomeScreen(_ sender: UIBarButtonItem) -> Void {
    self.clearAllVariables()
    self.langService.setLanguage(to: "pl")
    self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
    self.dismiss(animated: false)
  }
  
  @IBAction func saveSelectionToCart(_ sender: UIButton) -> Void {
    
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
      
      if Reachability.isConnectedToNetwork() {
        ClientService.sendClientToAPI(client: self.getFinalClient()) { (data, resp, error) in
          if let error = error {
            print(error.localizedDescription)
            print("error in BackEnd - Saving in Core Data")
            CoreDataManager.saveClientInCoreData(client: self.getFinalClient(), viewContext: appDelegate.persistentContainer.viewContext)
            appDelegate.saveContext()
          }
        }
      } else {
        print("NO INTERNET - Saving in Core Data")
        CoreDataManager.saveClientInCoreData(client: getFinalClient(), viewContext: appDelegate.persistentContainer.viewContext)
        appDelegate.saveContext()
      }
      
      showCompleteView()
      setViewAsCompleted()
    }
  }
  
  override func viewDidLoad() -> Void {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    backHomeScreen.tintColor = .clear
    translateTextKeys()
    formatSelectedDressesSection()
  }
  
  override func viewWillAppear(_ animated: Bool) -> Void {
    self.navigationController?.isNavigationBarHidden = false
  }
  
  private func translateTextKeys() -> Void {
    nameLabel.text = "home.client-info.name".localized() + " " + clientData.name
    surnameLabel.text = "home.client-info.lastname".localized() + " " + clientData.surname
    regionLabel.text = "home.client-info.region".localized() + " " + region
    dateOfWeddingLabel.text = "home.client-info.wedding-date".localized() + " " + clientData.dateOfWedding
    saveButton.setTitle("selection.confirm-button".localized().uppercased(), for: .normal)
    navigationItem.title = "selection.data.title".localized().uppercased()
    dressesLabel.setTitle("selection.dresses.title".localized().uppercased(), for: .normal)
  }
  
  private func clearAllVariables() -> Void {
    clientData = nil
    selectedDresses.removeAll()
    tableView = nil
  }
  
  private func formatSelectedDressesSection() -> Void {
    self.saveButton.roundCorners(from: .bottom, radius: 10)
    self.dressesLabel.roundCorners(from: .top, radius: 10)
  }
  
  private func getFinalClient() -> Client {
    clientData.region = self.region.localized() // SET POLISH LOCALIZATION HERE
    return clientData
  }
  
  private func setViewAsCompleted() -> Void {
    saveButton.isEnabled = false
    saveButton.alpha = 0.25
    self.navigationItem.hidesBackButton = true
    backHomeScreen.tintColor = .white
    backHomeScreen.isEnabled = true
  }
  
  private func showCompleteView() -> Void {
    let popCompleteView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompleteView") as! CompleteViewController
    self.addChild(popCompleteView)
    popCompleteView.view.frame = self.view.frame
    self.view.addSubview(popCompleteView.view)
    self.navigationController?.view.addSubview(popCompleteView.view)
    popCompleteView.didMove(toParent: self)
  }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------

extension SelectionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedDresses.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
      as! SelectionTableViewCell
    let dress = selectedDresses[indexPath.row]
    
    cell.dressLabel.font = UIFont(name: "TrajanPro-Regular", size: 32)
    cell.dressLabel.text = dress.name
    cell.dressImageView.image = UIImage(data: dress.imageData!)
    
    return cell
  }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------

extension SelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
    let popImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectedDressView") as! SelectedDressViewController
    popImageView.dressImage = selectedDresses[indexPath.row].imageData
    self.addChild(popImageView)
    popImageView.view.frame = self.view.frame
    self.view.addSubview(popImageView.view)
    self.navigationController?.view.addSubview(popImageView.view)
    popImageView.didMove(toParent: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
