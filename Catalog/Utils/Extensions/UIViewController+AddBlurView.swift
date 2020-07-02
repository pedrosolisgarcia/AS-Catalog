import UIKit

extension UIViewController {
  func addBlurView(below subView: UIView) -> Void {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    self.view.insertSubview(blurEffectView, belowSubview: subView)
  }
}
