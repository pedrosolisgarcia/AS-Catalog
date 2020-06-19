import UIKit

class SelectedDressViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var closeView: UIButton!
    @IBOutlet weak var popImageView: UIView!
    
    var dressImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(removeAnimate))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        self.view.removeFromSuperview()
        self.showAnimated()
        ImageView.image = UIImage(named: dressImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
    
    @IBAction func closeWindow(sender: UIButton) {
        self.removeAnimated()
    }
    
    @objc func removeAnimate() {
      self.removeAnimated()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
