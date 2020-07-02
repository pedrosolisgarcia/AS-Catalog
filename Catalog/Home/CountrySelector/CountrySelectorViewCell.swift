import UIKit

class CountrySelectorViewCell: UICollectionViewCell {
  
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var countryFlag: UIImageView!
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        self.contentView.backgroundColor = UIColor.golden.barelyTranslucent()
        self.countryLabel.textColor = .white
        self.countryFlag.alpha = 0.5
      }
      else {
        self.contentView.backgroundColor = .white
        self.countryLabel.textColor = .black
        self.countryFlag.alpha = 1
      }
    }
  }
}
