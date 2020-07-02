import UIKit

class CompleteViewController: UIViewController {
  
  @IBOutlet weak var popImageView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var doneButton: UIButton!
  var languageIndex: Int!
  
  var confirmationMessageLang: [[String]] = [["To wszystko","Dziękuję, proszę przekazać urządzenie pracownikowi salonu.","GOTOWE"],["Ready","Thank you, please give back the device to the person who attended you.","OK"],["LISTO","Gracias, devuelva el dispositivo a la persona que lo atendió.","Vale"]]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.popImageView.layer.cornerRadius = 20
    self.popImageView.layer.borderWidth = 5
    self.popImageView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    self.popImageView.layer.shadowColor = UIColor.gray.cgColor
    self.popImageView.layer.shadowOpacity = 0.75
    self.popImageView.layer.borderColor = UIColor.golden.cgColor
    
    let maskPathSave = UIBezierPath(roundedRect: doneButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 20.0, height: 20.0))
    
    let maskLayerSave = CAShapeLayer()
    maskLayerSave.path = maskPathSave.cgPath
    doneButton.layer.mask = maskLayerSave
    
    self.titleLabel.text = confirmationMessageLang[languageIndex][0]
    self.messageLabel.text = confirmationMessageLang[languageIndex][1]
    self.doneButton.setTitle(confirmationMessageLang[languageIndex][2], for: .normal)
    self.showAnimated()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func closeWindow(sender: UIButton) {
    self.removeAnimated()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
