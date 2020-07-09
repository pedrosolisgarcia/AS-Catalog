import UIKit

class CompleteViewController: UIViewController {
  
  @IBOutlet weak var popImageView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var doneButton: UIButton!

  override func viewDidLoad() -> Void {
    super.viewDidLoad()

    self.popImageView.layer.cornerRadius = 20
    self.popImageView.layer.borderWidth = 5
    self.popImageView.addViewShadow()
    self.popImageView.layer.borderColor = UIColor.catalogGolden.cgColor

    self.doneButton.roundCorners(from: .bottom, radius: 20)
    
    self.translateTextKeys()
    self.showAnimated()
  }
  
  @IBAction func closeWindow(sender: UIButton) -> Void {
    self.removeAnimated()
  }
  
  private func translateTextKeys() -> Void {
    self.titleLabel.text = "complete.title".localized().uppercased()
    self.messageLabel.text = "complete.message".localized()
    self.doneButton.setTitle("complete.button".localized().uppercased(), for: .normal)
  }
}
