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
        self.popImageView.layer.borderColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1).cgColor
        
        let maskPathSave = UIBezierPath(roundedRect: doneButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 20.0, height: 20.0))
        
        let maskLayerSave = CAShapeLayer()
        maskLayerSave.path = maskPathSave.cgPath
        doneButton.layer.mask = maskLayerSave
        
        self.titleLabel.text = confirmationMessageLang[languageIndex][0]
        self.messageLabel.text = confirmationMessageLang[languageIndex][1]
        self.doneButton.setTitle(confirmationMessageLang[languageIndex][2], for: .normal)
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeWindow(sender: UIButton) {
        self.removeAnimate()
    }
    
    func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
                self.dismiss(animated: false)
            }
        });
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
