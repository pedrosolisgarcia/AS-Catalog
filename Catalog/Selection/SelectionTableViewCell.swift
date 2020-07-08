import UIKit

class SelectionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var dressImageView: UIImageView!
  @IBOutlet weak var dressLabel: UILabel!

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
