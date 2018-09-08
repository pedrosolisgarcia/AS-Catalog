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
        self.showAnimate()
        ImageView.image = UIImage(named: dressImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
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
                self.ImageView.image = nil
                self.view.removeFromSuperview()
                self.dismiss(animated: false)
            }
        });
    }
}
