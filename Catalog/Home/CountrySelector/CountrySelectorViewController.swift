import UIKit

class CountrySelectorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var confirmButton: UIButton!
  
  var languageIndex: Int!
  
  var selectedCountry: Country!
  var countries = [Country]()
  weak var delegate: HomeViewController!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.isEditing = false
    collectionView.allowsSelection = true
    collectionView.allowsMultipleSelection = false
    self.showAnimated()
    headerLabel.text = LocalData.getLocalizationLabels(forElement: "headerLabel")[languageIndex]
    cancelButton.setTitle(LocalData.getLocalizationLabels(forElement: "cancelButton")[languageIndex], for: .normal)
    confirmButton.setTitle(LocalData.getLocalizationLabels(forElement: "confirmButton")[languageIndex], for: .normal)
    confirmButton.isEnabled = false
    confirmButton.alpha = 0.5
    
    let maskPathSave = UIBezierPath(roundedRect: confirmButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
    
    let maskLayerSave = CAShapeLayer()
    maskLayerSave.path = maskPathSave.cgPath
    confirmButton.layer.mask = maskLayerSave
    
    let maskPathLabel = UIBezierPath(roundedRect: headerLabel.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
    
    let maskLayerLabel = CAShapeLayer()
    maskLayerLabel.path = maskPathLabel.cgPath
    headerLabel.layer.mask = maskLayerLabel
    
    countries = LocalData.getCountries()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return countries.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CountrySelectorViewCell
    
    let country = countries[indexPath.row]
    
    cell.countryLabel.text = country.name[languageIndex]
    cell.countryFlag.image = UIImage(named: country.imgName)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedCountry = countries[indexPath.row]
    confirmButton.isEnabled = true
    confirmButton.alpha = 1
  }
  
  @IBAction func removeAnimate(sender: UIButton) {
    
    UIView.animate(withDuration: 0.25, animations: {
      self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      self.view.alpha = 0.0;
    }, completion:{(finished : Bool)  in
      if (finished) {
        if sender == self.confirmButton {
          self.delegate.regionLabel.text = LocalData.getLocalizationLabels(forElement: "countryLabel")[self.languageIndex]
          self.delegate.setCountryField(country: self.selectedCountry)
        }
        if sender == self.cancelButton {
          self.delegate.setCountryField(country: Country(name:["","",""],imgName:""))
        }
        if (self.delegate.view.gestureRecognizers?.isEmpty)! {
          self.view.addDismissKeyboardListener()
        }
        self.view.removeFromSuperview()
        self.dismiss(animated: false)
      }
    });
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}