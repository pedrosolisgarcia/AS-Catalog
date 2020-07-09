import UIKit

extension UIColor {
  func veryTranslucent() -> UIColor {
    return self.withAlphaComponent(0.25)
  }

  func midTranslucent() -> UIColor {
    return self.withAlphaComponent(0.5)
  }
  
  func barelyTranslucent() -> UIColor {
    return self.withAlphaComponent(0.75)
  }
}
