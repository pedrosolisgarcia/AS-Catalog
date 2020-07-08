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
  

  override func viewDidLoad() -> Void {
    super.viewDidLoad()
    
    self.isEditing = false
    collectionView.allowsSelection = true
    collectionView.allowsMultipleSelection = false

    confirmButton.isEnabled = false
    confirmButton.alpha = 0.5

    self.translateTextKeys()
    self.countrySelectorView.addViewShadow()
    self.cancelButton.addButtonShadow()
    self.confirmButton.roundCorners(from: .bottom, radius: 10)
    self.headerLabel.roundCorners(from: .top, radius: 10)
    self.showAnimated()
  }
  
  private func translateTextKeys() -> Void {
    self.headerLabel.text = "country-selector.title".localized().uppercased()
    self.confirmButton.setTitle("alert.confirm-button".localized(), for: .normal)
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void {
    selectedCountry = countries[indexPath.row]
    confirmButton.isEnabled = true
    confirmButton.alpha = 1
  }
  
  @IBAction func removeAnimate(sender: UIButton) -> Void {
    
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
}
