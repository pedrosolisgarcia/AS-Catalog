import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 0.75)
                self.countryLabel.textColor = UIColor.white
                self.countryFlag.alpha = 0.5
            }
            else {
                self.contentView.backgroundColor = UIColor.white
                self.countryLabel.textColor = UIColor.black
                self.countryFlag.alpha = 1
            }
        }
    }
}
