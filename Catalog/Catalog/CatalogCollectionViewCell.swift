import UIKit

protocol CatalogCollectionViewCellDelegate: class {
  func didPressZoomButton(_ sender: UIButton)
}

class CatalogCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var dressImageView: UIImageView!
  @IBOutlet weak var dressLabel: UILabel!
  @IBOutlet weak var selectedFlag: UIImageView!
  weak var cellDelegate: CatalogCollectionViewCellDelegate?
  
  @IBAction func buttonPressed(_ sender: UIButton) -> Void {
    cellDelegate?.didPressZoomButton(sender)
  }
  
  override var isSelected: Bool {
    didSet {
      self.selectedFlag.image = isSelected ? UIImage(named: "tick") : nil
      self.dressLabel.backgroundColor = isSelected ? UIColor.golden.barelyTranslucent() : UIColor.black.veryTranslucent()
    }
  }
}
