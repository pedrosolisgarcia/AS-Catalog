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
  
  var selectedDresses = [CollectionDresses]()
  var currentClient: Client!
  var region = String()
  var collectionId: Int!
  
  @IBAction func backToHomeScreen(_ sender: UIBarButtonItem) {
    
    clearAllVariables()
    self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
    self.dismiss(animated: false)
  }
  
  @IBAction func saveSelectionToCart(_ sender: UIButton) {
    
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    backHomeScreen.tintColor = .clear
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
    cell.dressLabel.text = dress.name
    cell.dressImageView.image = UIImage(data: dress.imageData!)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let popImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectedDressView") as! SelectedDressViewController
    popImageView.dressImage = selectedDresses[indexPath.row].imageData
    self.addChild(popImageView)
    popImageView.view.frame = self.view.frame
    self.view.addSubview(popImageView.view)
    self.navigationController?.view.addSubview(popImageView.view)
    popImageView.didMove(toParent: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  private func applyLanguage() {
    nameLabel.text = "home.client-info.name".localized() + " " + currentClient.name
    surnameLabel.text = "home.client-info.lastname".localized() + " " + currentClient.surname
    regionLabel.text = "home.client-info.region".localized() + " " + region.localized()
    dateOfWeddingLabel.text = "home.client-info.wedding-date".localized() + " " + currentClient.dateOfWedding
    saveButton.setTitle("selection.confirm-button".localized().uppercased(), for: .normal)
    navigationItem.title = "selection.data.title".localized().uppercased()
    dressesLabel.setTitle("selection.dresses.title".localized().uppercased(), for: .normal)
  }
  
  private func clearAllVariables() {
    currentClient = nil
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
  
  private func getFinalClient() -> Client {
    currentClient.region = self.region != "" ?
      self.region : self.region// SET POLISH LOCALIZATION HERE
    return currentClient
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
