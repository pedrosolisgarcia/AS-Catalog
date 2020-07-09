import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var zoomInView : UIScrollView!
  @IBOutlet weak var dressImageView: UIImageView!
  @IBOutlet weak var zoomOutButton: UIButton!
  var dress: UIImage!

  override func viewDidLoad() -> Void {
    super.viewDidLoad()

    self.view.removeFromSuperview()
    self.showAnimated()
    zoomInView.delegate = self
    dressImageView.image = dress
    zoomOutButton.isEnabled = true
    zoomOutButton.alpha = 0.75
    setupGestureRecognizer()
  }
  
  override func viewWillAppear(_ animated: Bool) -> Void {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = true
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return dressImageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) -> Void {
    if zoomInView.zoomScale == zoomInView.minimumZoomScale {
      zoomOutButton.isEnabled = true
      zoomOutButton.alpha = 0.75
    } else {
      zoomOutButton.isEnabled = false
      zoomOutButton.alpha = 0
    }
  }
  
  private func setupGestureRecognizer() -> Void {
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector (handleDoubleTap))
    doubleTap.numberOfTapsRequired = 2
    zoomInView.addGestureRecognizer(doubleTap)
  }
  
  @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) -> Void {
    
    if zoomInView.zoomScale > zoomInView.minimumZoomScale {
      zoomInView.setZoomScale(zoomInView.minimumZoomScale, animated: true)
    } else {

      let touchPoint = recognizer.location(in: view)
      let scrollViewSize = zoomInView.bounds.size
      let width = scrollViewSize.width / zoomInView.maximumZoomScale
      let height = scrollViewSize.height / zoomInView.maximumZoomScale
      let x = touchPoint.x - (width/2.0)
      let y = touchPoint.y - (height/2.0)
      let rect = CGRect(x:x,y:y,width:width,height:height)
      zoomInView.zoom(to: rect, animated: true)
    }
  }
  
  @IBAction func zoomOut(sender: UIButton) -> Void {
    self.removeAnimated()
    self.navigationController?.isNavigationBarHidden = false
  }
}
