import UIKit

extension UIView {
  func addButtonShadow() -> Void {
    self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowRadius = 0
    self.layer.shadowOpacity = 1
  }
  
  func addViewShadow() -> Void {
    self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOpacity = 0.75
  }
}
