import UIKit

class CountrySelectorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var countrySelectorView: UIView!
  
  var selectedCountry: Country!
  var countries: [Country] = LocalDataService.shared.getCountries()!
  weak var delegate: HomeViewController!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.isEditing = false
    collectionView.allowsSelection = true
    collectionView.allowsMultipleSelection = false
    self.showAnimated()
    headerLabel.text = "country-selector.title".localized().uppercased()
    confirmButton.setTitle("alert.confirm-button".localized(), for: .normal)
    confirmButton.isEnabled = false
    confirmButton.alpha = 0.5
    
    self.countrySelectorView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    self.countrySelectorView.layer.shadowColor = UIColor.gray.cgColor
    self.countrySelectorView.layer.shadowOpacity = 0.75
    
    self.cancelButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    self.cancelButton.layer.shadowColor = UIColor.gray.cgColor
    self.cancelButton.layer.shadowRadius = 0
    self.cancelButton.layer.shadowOpacity = 1
    
    let maskPathSave = UIBezierPath(roundedRect: confirmButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
    
    let maskLayerSave = CAShapeLayer()
    maskLayerSave.path = maskPathSave.cgPath
    confirmButton.layer.mask = maskLayerSave
    
    let maskPathLabel = UIBezierPath(roundedRect: headerLabel.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
    
    let maskLayerLabel = CAShapeLayer()
    maskLayerLabel.path = maskPathLabel.cgPath
    headerLabel.layer.mask = maskLayerLabel
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
    
    cell.countryLabel.text = country.name.localized()
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
          self.delegate.regionLabel.text = "home.client-info.country".localized()
          self.delegate.setCountryField(country: self.selectedCountry)
        }
        if sender == self.cancelButton {
          self.delegate.setCountryField(country: Country(name:"",imgName:""))
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
