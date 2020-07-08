import UIKit

extension UIView {
  func addDismissKeyboardListener() -> Void {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    
    tap.cancelsTouchesInView = false
    self.addGestureRecognizer(tap)
  }
}
